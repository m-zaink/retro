// **
// Created by Mohammed Sadiq on 28/05/20.
// **

import 'package:flutter/material.dart';
import 'package:retro/asset_images_url.dart';

class RetroScreen extends StatefulWidget {
  final List<Color> channels = [
    Colors.purple,
    Colors.indigo,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.red,
  ];

  final Color tvOffChannel = Colors.black;

  @override
  _RetroScreenState createState() => _RetroScreenState();
}

class _RetroScreenState extends State<RetroScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
      key: _scaffoldKey,
      appBar: _retroAppBar,
      backgroundColor: _backgroundColor,
      body: _retroBody,
    );
  }

  Color get _backgroundColor => Colors.black;

  Widget get _retroAppBar => AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () => setState(_flipRetroVisible),
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

  Widget get _retroBody => Container(
        child: _retroVisible
            ? _retroLogo
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _tv,
                  _volumeIndicator,
                  _remote,
                  _copyRightRetroRemote,
                ],
              ),
      );

  void _flipRetroVisible() => _retroVisible = !_retroVisible;

  Widget get _retroLogo => Center(
        child: Image.asset(
          AssetImagesURL.kRetroLogo,
          height: 300,
        ),
      );

  Widget get _tv => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: GestureDetector(
          onTap: _powerButtonClicked,
          child: Container(
            color: _currentChannel,
            child: Image.asset(
              AssetImagesURL.kRetroTV,
            ),
          ),
        ),
      );

  Widget get _volumeIndicator => SliderTheme(
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

  Widget get _remote => Column(
        children: [
          _nextChannelButton,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _volumeDownButton,
              _powerButton,
              _volumeUpButton,
            ],
          ),
          _previousChannelButton
        ],
      );

  Widget get _nextChannelButton => Column(
        children: [
          Text(
            'Ch+',
            style: TextStyle(color: Colors.white),
          ),
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_up,
              color: Colors.white,
            ),
            onPressed: _nextChannelButtonClicked,
          ),
        ],
      );

  Widget get _previousChannelButton => Column(
        children: [
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
            onPressed: _previousChannelButtonClick,
          ),
          Text(
            'Ch-',
            style: TextStyle(color: Colors.white),
          ),
        ],
      );

  Widget get _volumeUpButton => Expanded(
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
            Text(
              'Vol+',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );

  Widget get _volumeDownButton => Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Vol-',
              style: TextStyle(color: Colors.white),
            ),
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

  Widget get _powerButton => Expanded(
        child: IconButton(
          icon: Icon(
            Icons.power_settings_new,
            color: Colors.white,
          ),
          onPressed: _powerButtonClicked,
        ),
      );

  Widget get _copyRightRetroRemote => Center(
        child: Column(
          children: [
            Text(
              '© Retro Remote',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'm_zaink',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      );

  void _powerButtonClicked() {
    if (_tvIsOff) {
      _currentChannel = _lastPlayedChannel;
    } else {
      _currentChannel = widget.tvOffChannel;
    }
    flipTvIsOff();

    setState(() {});
  }

  void flipTvIsOff() => _tvIsOff = !_tvIsOff;

  void _nextChannelButtonClicked() {
    if (_tvIsNotOff) {
      _currentChannel = _nextChannel;
      setState(() {});
    } else {
      showSnackBarForTVTurnedOff();
    }
  }

  void _previousChannelButtonClick() {
    if (_tvIsNotOff) {
      _currentChannel = _prevChannel;
      setState(() {});
    } else {
      showSnackBarForTVTurnedOff();
    }
  }

  void _volumeUpButtonClicked() {
    if (_tvIsNotOff) {
      _currentVolume = _nextVolume;
      setState(() {});
    } else {
      showSnackBarForTVTurnedOff();
    }
  }

  void _volumeDownButtonClicked() {
    if (_tvIsNotOff) {
      _currentVolume = _prevVolume;
      setState(() {});
    } else {
      showSnackBarForTVTurnedOff();
    }
  }

  void showSnackBarForTVTurnedOff() => _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.blue,
          duration: Duration(
            seconds: 1,
            milliseconds: 500,
          ),
          content: Text('TV is turned off. Please turn on and try again.'),
        ),
      );

  bool get _tvIsNotOff => !_tvIsOff;

  int get _nextChannelIndex =>
      _currentChannelIndex = (++_currentChannelIndex) % widget.channels.length;

  int get _prevChannelIndex =>
      _currentChannelIndex = (--_currentChannelIndex) % widget.channels.length;

  int get _nextVolume =>
      _currentVolume == 100 ? 100 : (_currentVolume + 5) % 105;

  int get _prevVolume => _currentVolume == 0 ? 0 : (_currentVolume - 5) % 105;

  Color get _nextChannel => widget.channels[_nextChannelIndex];

  Color get _prevChannel => widget.channels[_prevChannelIndex];

  Color get _lastPlayedChannel => widget.channels[_currentChannelIndex];
}
