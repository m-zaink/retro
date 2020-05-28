// **
// Created by Mohammed Sadiq on 28/05/20.
// **

import 'dart:ffi';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final List<Color> channels = [
    Colors.purple,
    Colors.indigo,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.orange,
  ];

  final Color tvOffChannel = Colors.black;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _retroVisible = false;
  int _currentChannelIndex = 0;
  bool _tvIsOff = true;
  int _currentVolume = 0;
  Color _currentChannel;

  @override
  void initState() {
    _currentChannel = widget.tvOffChannel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: _retroVisible
              ? retroLogo
              : Column(
                  children: [
                    Spacer(),
                    tv,
                    Spacer(),
                    volumeIndicator,
                    Spacer(),
                    remote,
                    Spacer(),
                    copyRightRetroRemote,
                  ],
                ),
        ),
      ),
    );
  }

  Widget get retroLogo => Center(
        child: Image.asset(
          'images/retro_logo.png',
          height: 300,
        ),
      );

  Widget get appBar => AppBar(
        title: GestureDetector(
          onTap: () {
            setState(() => _retroVisible = !_retroVisible);
          },
          child: Text(
            'Retro',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0.0,
      );

  Widget get tv => Container(
        color: _currentChannel,
        child: Image.asset(
          'images/retro_tv.png',
          width: MediaQuery.of(context).size.width * 0.9,
        ),
      );

  Widget get volumeIndicator => SliderTheme(
        data: SliderThemeData(
          thumbShape: SliderComponentShape.noThumb,
        ),
        child: Slider(
          activeColor: _currentChannel,
          inactiveColor: _currentChannel.withOpacity(0.3),
          onChanged: (_) {},
          value: _currentVolume / 100.0,
          max: 1.0,
          min: 0.0,
        ),
      );

  Widget get remote => Column(
        children: [
          nextChannelButton,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              volumeDownButton,
              powerButton,
              volumeUpButton,
            ],
          ),
          previousChannelButton
        ],
      );

  Widget get nextChannelButton => Column(
        children: [
          Text('Ch+'),
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_up,
              color: Colors.white,
            ),
            onPressed: _nextChannelButtonClicked,
          ),
        ],
      );

  Widget get previousChannelButton => Column(
        children: [
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
            onPressed: _previousChannelButtonClick,
          ),
          Text('Ch-'),
        ],
      );

  Widget get volumeUpButton => Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              onPressed: _volumeUpButtonClicked,
            ),
            Text('Vol+'),
          ],
        ),
      );

  Widget get volumeDownButton => Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Vol-'),
            IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
              onPressed: _volumeDownButtonClicked,
            ),
          ],
        ),
      );

  Widget get powerButton => Expanded(
        child: IconButton(
          icon: Icon(
            Icons.power_settings_new,
            color: Colors.white,
          ),
          onPressed: _powerButtonClicked,
        ),
      );

  Widget get copyRightRetroRemote => Center(
        child: Text(
          '© Retro Remote',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );

  void _powerButtonClicked() {
    if (_tvIsOff) {
      _currentChannel = widget.channels[_currentChannelIndex];
    } else {
      _currentChannel = widget.tvOffChannel;
    }
    flipTvIsOff();

    setState(() {});
  }

  void flipTvIsOff() => _tvIsOff = !_tvIsOff;

  void _nextChannelButtonClicked() {
    if (tvIsNotOff) {
      _currentChannel = nextChannel;
      setState(() {});
    }
  }

  void _previousChannelButtonClick() {
    if (tvIsNotOff) {
      _currentChannel = prevChannel;
      setState(() {});
    }
  }

  void _volumeUpButtonClicked() {
    if (tvIsNotOff) {
      _currentVolume = nextVolume;
      setState(() {});
    }
  }

  void _volumeDownButtonClicked() {
    if (tvIsNotOff) {
      _currentVolume = prevVolume;
      setState(() {});
    }
  }

  bool get tvIsNotOff => !_tvIsOff;

  Color get nextChannel =>
      widget.channels[++_currentChannelIndex % widget.channels.length];

  Color get prevChannel =>
      widget.channels[--_currentChannelIndex % widget.channels.length];

  int get nextVolume =>
      _currentVolume == 100 ? 100 : (_currentVolume + 5) % 105;

  int get prevVolume => _currentVolume == 0 ? 0 : (_currentVolume - 5) % 105;
}
