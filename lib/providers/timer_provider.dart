import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/timer_settings.dart';
import '../models/hour_tracker.dart';

enum TimerState { idle, running, paused }

enum SessionType { work, shortBreak, longBreak }

class TimerProvider extends ChangeNotifier {
  TimerSettings _settings = const TimerSettings();
  HourTracker _hourTracker = HourTracker();
  TimerState _timerState = TimerState.idle;
  SessionType _sessionType = SessionType.work;
  int _remainingSeconds = 25 * 60;
  int _completedSessions = 0;
  List<String> _labels = ['Study', 'Work', 'Workout', 'Reading'];
  String _selectedLabel = 'Study';
  Timer? _timer;

  TimerSettings get settings => _settings;
  HourTracker get hourTracker => _hourTracker;
  TimerState get timerState => _timerState;
  SessionType get sessionType => _sessionType;
  int get remainingSeconds => _remainingSeconds;
  int get completedSessions => _completedSessions;
  List<String> get labels => _labels;
  String get selectedLabel => _selectedLabel;

  double get progress {
    final totalSeconds = _getCurrentSessionDuration() * 60;
    return 1 - (_remainingSeconds / totalSeconds);
  }

  String get formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get sessionLabel {
    switch (_sessionType) {
      case SessionType.work:
        return 'Focus Time';
      case SessionType.shortBreak:
        return 'Short Break';
      case SessionType.longBreak:
        return 'Long Break';
    }
  }

  TimerProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load settings
    final settingsJson = prefs.getString('timer_settings');
    if (settingsJson != null) {
      _settings = TimerSettings.fromJson(jsonDecode(settingsJson));
    }

    // Load labels
    final labelsJson = prefs.getString('labels');
    if (labelsJson != null) {
      _labels = List<String>.from(jsonDecode(labelsJson));
    }

    // Load selected label
    final selectedLabel = prefs.getString('selected_label');
    if (selectedLabel != null && _labels.contains(selectedLabel)) {
      _selectedLabel = selectedLabel;
    } else if (_labels.isNotEmpty) {
      _selectedLabel = _labels.first;
    }

    // Load hour tracker
    final hourTrackerJson = prefs.getString('hour_tracker');
    if (hourTrackerJson != null) {
      _hourTracker = HourTracker.fromJson(jsonDecode(hourTrackerJson));
    }

    _remainingSeconds = _settings.workDuration * 60;
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('timer_settings', jsonEncode(_settings.toJson()));
    await prefs.setString('hour_tracker', jsonEncode(_hourTracker.toJson()));
    await prefs.setString('labels', jsonEncode(_labels));
    await prefs.setString('selected_label', _selectedLabel);
  }

  int _getCurrentSessionDuration() {
    switch (_sessionType) {
      case SessionType.work:
        return _settings.workDuration;
      case SessionType.shortBreak:
        return _settings.shortBreakDuration;
      case SessionType.longBreak:
        return _settings.longBreakDuration;
    }
  }

  void startTimer() {
    if (_timerState == TimerState.running) return;

    _timerState = TimerState.running;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;

        // Track time for work sessions
        if (_sessionType == SessionType.work) {
          _hourTracker.addSeconds(1);
          _saveData();
        }

        notifyListeners();
      } else {
        _onSessionComplete();
      }
    });
    notifyListeners();
  }

  void pauseTimer() {
    _timer?.cancel();
    _timerState = TimerState.paused;
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    _timerState = TimerState.idle;
    _remainingSeconds = _getCurrentSessionDuration() * 60;
    notifyListeners();
  }

  void _onSessionComplete() {
    _timer?.cancel();

    if (_sessionType == SessionType.work) {
      _completedSessions++;

      if (_completedSessions >= _settings.sessionsBeforeLongBreak) {
        _sessionType = SessionType.longBreak;
        _completedSessions = 0;
      } else {
        _sessionType = SessionType.shortBreak;
      }
    } else {
      _sessionType = SessionType.work;
    }

    _remainingSeconds = _getCurrentSessionDuration() * 60;
    _timerState = TimerState.idle;
    _saveData();
    notifyListeners();
  }

  void skipSession() {
    _timer?.cancel();
    _onSessionComplete();
  }

  void updateSettings(TimerSettings newSettings) {
    _settings = newSettings;
    if (_timerState == TimerState.idle) {
      _remainingSeconds = _getCurrentSessionDuration() * 60;
    }
    _saveData();
    notifyListeners();
  }

  void resetHourTracker() {
    _hourTracker.reset();
    _saveData();
    notifyListeners();
  }

  void addLabel(String label) {
    if (!_labels.contains(label)) {
      _labels.add(label);
      _saveData();
      notifyListeners();
    }
  }

  void selectLabel(String label) {
    if (_labels.contains(label)) {
      _selectedLabel = label;
      _saveData();
      notifyListeners();
    }
  }

  void deleteLabel(String label) {
    if (_labels.length > 1 && _labels.contains(label)) {
      _labels.remove(label);
      if (_selectedLabel == label) {
        _selectedLabel = _labels.first;
      }
      _saveData();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
