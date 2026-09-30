const _channel0Frequency = 2407;
const _channel14Frequency = 2484;
const _channelWidth = 5;

int wifiFrequencyToChannel(int frequency) {
  if (frequency == _channel14Frequency) {
    return 14;
  }
  return (frequency - _channel0Frequency) ~/ _channelWidth;
}

int wifiChannelToFrequency(int channel) {
  if (channel == 14) {
    return _channel14Frequency;
  }
  return _channel0Frequency + channel * _channelWidth;
}
