import 'dart:async';

typedef void OnTimerTickCallback(int millisUntilFinished);

class TimerUtil {
  TimerUtil({this.mInterval = Duration.millisecondsPerSecond, this.mTotalTime});

  Timer _mTimer;

  bool _isActive = false;

  int mInterval;

  int mTotalTime; //单位毫秒

  OnTimerTickCallback _onTimerTickCallback;

  void setInterval(int interval) {
    if (interval <= 0) interval = Duration.millisecondsPerSecond;
    mInterval = interval;
  }

  void setTotalTime(int totalTime) {
    if (totalTime <= 0) return;
    mTotalTime = totalTime;
  }

  void startTimer() {
    if (_isActive || mInterval <= 0) return;
    _isActive = true;
    Duration duration = Duration(milliseconds: mInterval);
    _doCallback(0);
    _mTimer = Timer.periodic(duration, (Timer timer) {
      _doCallback(timer.tick);
    });
  }

  void startCountDown() {
    if (_isActive || mInterval <= 0 || mTotalTime <= 0) return;
    _isActive = true;
    Duration duration = Duration(milliseconds: mInterval);
    _doCallback(mTotalTime);
    _mTimer = Timer.periodic(duration, (Timer timer) {
      int time = mTotalTime - mInterval;
      mTotalTime = time;
      if (time >= mInterval) {
        _doCallback(time);
      } else if (time == 0) {
        _doCallback(time);
        cancel();
      } else {
        timer.cancel();
        Future.delayed(Duration(milliseconds: time), () {
          mTotalTime = 0;
          _doCallback(0);
          cancel();
        });
      }
    });
  }

  void _doCallback(int time) {
    if (_onTimerTickCallback != null) {
      _onTimerTickCallback(time);
    }
  }

  void updateTotalTime(int totalTime) {
    cancel();
    mTotalTime = totalTime;
    startCountDown();
  }

  bool isActive() {
    return _isActive;
  }

  void cancel() {
    if (_mTimer != null) {
      _mTimer.cancel();
      _mTimer = null;
    }
    _isActive = false;
  }

  void setOnTimerTickCallback(OnTimerTickCallback callback) {
    _onTimerTickCallback = callback;
  }
}
