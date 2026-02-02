class HourTracker {
  int _totalSeconds;

  HourTracker({int totalSeconds = 0}) : _totalSeconds = totalSeconds;

  int get totalSeconds => _totalSeconds;

  void addSeconds(int seconds) {
    _totalSeconds += seconds;
  }

  void reset() {
    _totalSeconds = 0;
  }

  double get totalHours => _totalSeconds / 3600;

  String get formattedHours {
    final hours = _totalSeconds ~/ 3600;
    final minutes = (_totalSeconds % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get detailedFormat {
    final hours = _totalSeconds ~/ 3600;
    final minutes = (_totalSeconds % 3600) ~/ 60;
    final seconds = _totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toJson() {
    return {'totalSeconds': _totalSeconds};
  }

  factory HourTracker.fromJson(Map<String, dynamic> json) {
    return HourTracker(totalSeconds: json['totalSeconds'] ?? 0);
  }
}
