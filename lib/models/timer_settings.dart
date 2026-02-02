class TimerSettings {
  final int workDuration; // in minutes
  final int shortBreakDuration; // in minutes
  final int longBreakDuration; // in minutes
  final int sessionsBeforeLongBreak;

  const TimerSettings({
    this.workDuration = 25,
    this.shortBreakDuration = 5,
    this.longBreakDuration = 15,
    this.sessionsBeforeLongBreak = 4,
  });

  TimerSettings copyWith({
    int? workDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
    int? sessionsBeforeLongBreak,
  }) {
    return TimerSettings(
      workDuration: workDuration ?? this.workDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      sessionsBeforeLongBreak:
          sessionsBeforeLongBreak ?? this.sessionsBeforeLongBreak,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workDuration': workDuration,
      'shortBreakDuration': shortBreakDuration,
      'longBreakDuration': longBreakDuration,
      'sessionsBeforeLongBreak': sessionsBeforeLongBreak,
    };
  }

  factory TimerSettings.fromJson(Map<String, dynamic> json) {
    return TimerSettings(
      workDuration: json['workDuration'] ?? 25,
      shortBreakDuration: json['shortBreakDuration'] ?? 5,
      longBreakDuration: json['longBreakDuration'] ?? 15,
      sessionsBeforeLongBreak: json['sessionsBeforeLongBreak'] ?? 4,
    );
  }
}
