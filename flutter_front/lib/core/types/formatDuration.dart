String formatDuration(double seconds) {
  final duration = Duration(seconds: seconds.round());
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final remainingSeconds = duration.inSeconds.remainder(60);

  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}ч ${minutes.toString().padLeft(2, '0')}м';
  } else {
    return '${minutes.toString().padLeft(2, '0')}м ${remainingSeconds.toString().padLeft(2, '0')}с';
  }
}