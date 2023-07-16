import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

//API
// https://api.dictionaryapi.dev/api/v2/entries/en/bad    #for word search
// https://random-words-api.vercel.app/word     #for word of the day
// https://coffee.alexflipnote.dev/random    #coffie of the day
// https://foodish-api.herokuapp.com/images/burger/    #burger of the day
// https://foodish-api.herokuapp.com/   #dishes of the day
// https://api.adviceslip.com/advice  #advice of the day
// https://www.affirmations.dev/ #affirmation of the day
// https://inspiration.goprogram.ai/ #quotes of the day (update every hour)
// https://quote-garden.herokuapp.com/api/v3/quotes/random  #random motivational quote

class DictionaryBody extends StatefulWidget {
  const DictionaryBody({Key? key}) : super(key: key);

  @override
  _DictionaryBodyState createState() => _DictionaryBodyState();
}

class _DictionaryBodyState extends State<DictionaryBody> {
  final TextEditingController _inputController = TextEditingController();
  String _inputWord = '';

  var _data;
  String isFinded = '';

  void callApis(String word) {
    setState(() {
      isFinded = 'processing';
    });
    var url =
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word');

    http.get(url).then((result) {
      //print(result.statusCode);

      setState(() {
        if (result.statusCode == 200) {
          _data = json.decode(result.body);
          isFinded = 'true';
        } else {
          isFinded = 'false';
        }
      });
    });
  }

  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  play(voice) async {
    int result = await audioPlayer.play('https:' + voice);
    if (result == 1) {
      // success
    }
  }

  String _saveTxt = 'Save';

  Color _saveColor = Colors.grey;

  _saveResult() {
    if(_saveTxt == 'Save'){
      setState(() {
        _saveTxt = 'Saved';
        _saveColor = Colors.pink;
      });
    }else{
      setState(() {
        _saveTxt = 'Save';
        _saveColor = Colors.grey;
      });
    }

    _saveTxt = 'Save';
    _saveColor = Colors.grey;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(height: 20),
        Card(
          elevation: 2,
          color: Colors.grey[150],
          //margin: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white70, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 60 / 100,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Mini Dicy',
                      style: GoogleFonts.roboto(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(30),
                        FilteringTextInputFormatter.allow(RegExp("[a-z,A-Z]")),
                      ],
                      textInputAction: TextInputAction.search,
                      controller: _inputController,
                      onChanged: (val) => setState(() {
                        if (val == '') {
                          isFinded = '';
                        }
                        _inputWord = val.trim();
                      }),
                      onFieldSubmitted: (val) {
                        if (_inputWord != '') {
                          callApis(_inputWord);
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 17, horizontal: 0),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.teal, width: 1.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        hintText: 'Search a word',
                        hintStyle: GoogleFonts.lato(color: Colors.grey[600]),
                        prefixIcon: const Icon(
                          Ionicons.search_outline,
                          color: Colors.grey,
                          size: 26,
                        ),
                        helperText: (isFinded == '')
                            ? 'Type any existing word and press enter to get meaning, example, synonyms, ect.'
                            : (isFinded == 'processing' && _inputWord != '')
                                ? 'Searching...'
                                : null,
                        errorText: (_inputWord != '' && isFinded == 'false')
                            ? 'Can\'t find the meaning of "$_inputWord". Please, try to search for another word.'
                            : null,
                        helperMaxLines: 2,
                        errorMaxLines: 3,
                        helperStyle:
                            GoogleFonts.lato(fontSize: 12, letterSpacing: 0.6),
                        errorStyle:
                            GoogleFonts.lato(fontSize: 12, letterSpacing: 0.6),
                        suffixIcon: _inputWord != ''
                            ? IconButton(
                                splashRadius: 25,
                                onPressed: () {
                                  setState(() {
                                    _inputController.clear();
                                    _inputWord = '';
                                    isFinded = '';
                                  });
                                },
                                icon: const Icon(
                                  Ionicons.close_outline,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ),
                  ),
                  //const SizedBox(height: 10,),
                  (isFinded == 'true')
                      ? SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: SizedBox(
                                  width:MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                _data[0]['word'][0]
                                                        .toUpperCase() +
                                                    _data[0]['word'].substring(1),
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600)),
                                            const SizedBox(height: 5),
                                            const Text('Results:',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
                                      (!_data[0]['phonetics'][0].isEmpty)
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      play(_data[0]['phonetics']
                                                          [0]['audio']);
                                                    },
                                                    padding: EdgeInsets.zero,
                                                    icon: const Icon(
                                                      Ionicons
                                                          .volume_high_outline,
                                                      color: Colors.grey,
                                                      size: 28,
                                                    )),
                                                Text('/${_data[0]['phonetic']}',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey))
                                              ],
                                            )
                                          : Container(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                _saveResult();
                                              },
                                              padding: EdgeInsets.zero,
                                              icon: Icon(
                                                Ionicons.archive_outline,
                                                color: _saveColor,
                                                size: 28,
                                              )),
                                          Text(_saveTxt,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Scrollbar(
                                showTrackOnHover: true,
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      40 /
                                      100,
                                  child: ListView.builder(
                                      itemCount: _data[0]['meanings'].length,
                                      itemBuilder: (context, i) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 5),
                                              child: Text(
                                                  '/${_data[0]['meanings'][i]['partOfSpeech']}',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Colors.orangeAccent,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.2)),
                                            ),

                                            //Todo:Definition

                                            (_data[0]['meanings'][i]
                                                            ['definitions'][0]
                                                        .containsKey(
                                                            'definition') &&
                                                    !_data[0]['meanings'][i]
                                                                ['definitions']
                                                            [0]['definition']
                                                        .isEmpty)
                                                ? ListTile(
                                                    horizontalTitleGap: -20,
                                                    leading: Container(
                                                      color: Colors.teal,
                                                      width: 2,
                                                    ),
                                                    subtitle: const Text(
                                                        'Definition',
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                    title: Text(
                                                      _data[0]['meanings'][i]['definitions']
                                                                          [0][
                                                                      'definition']
                                                                  [0]
                                                              .toUpperCase() +
                                                          _data[0]['meanings']
                                                                          [i][
                                                                      'definitions'][0]
                                                                  ['definition']
                                                              .substring(1),
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  )
                                                : const SizedBox(),

                                            //Todo:Example

                                            (_data[0]['meanings'][i]
                                                            ['definitions'][0]
                                                        .containsKey(
                                                            'example') &&
                                                    !_data[0]['meanings'][i]
                                                                ['definitions']
                                                            [0]['example']
                                                        .isEmpty)
                                                ? ListTile(
                                                    horizontalTitleGap: -20,
                                                    leading: Container(
                                                      color: Colors.teal,
                                                      width: 2,
                                                    ),
                                                    subtitle: const Text(
                                                        'Example',
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                    title: Text(
                                                      _data[0]['meanings'][i][
                                                                      'definitions'][0]
                                                                  ['example'][0]
                                                              .toUpperCase() +
                                                          _data[0]['meanings']
                                                                          [i][
                                                                      'definitions']
                                                                  [0]['example']
                                                              .substring(1),
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  )
                                                : const SizedBox(),

                                            //Todo: Synonyms

                                            (_data[0]['meanings'][i]
                                                            ['definitions'][0]
                                                        .containsKey(
                                                            'synonyms') &&
                                                    !_data[0]['meanings'][i]
                                                                ['definitions']
                                                            [0]['synonyms']
                                                        .isEmpty)
                                                ? ListTile(
                                                    horizontalTitleGap: -20,
                                                    leading: Container(
                                                      color: Colors.teal,
                                                      width: 2,
                                                    ),
                                                    subtitle: const Text(
                                                        'Synonyms',
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                    title: Text(
                                                      _fecthSynonyms(_data[0]
                                                                  ['meanings']
                                                              [i]['definitions']
                                                          [0]['synonyms']),
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: const TextStyle(
                                                          wordSpacing: 2),
                                                    ),
                                                  )
                                                : const SizedBox(),

                                            //Todo: Antonyms

                                            (_data[0]['meanings'][i]
                                                            ['definitions'][0]
                                                        .containsKey(
                                                            'antonyms') &&
                                                    !_data[0]['meanings'][i]
                                                                ['definitions']
                                                            [0]['antonyms']
                                                        .isEmpty)
                                                ? ListTile(
                                                    leading: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                        ),
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  5.0),
                                                          child: Icon(
                                                            Icons.edit_outlined,
                                                            color: Colors.teal,
                                                            size: 20,
                                                          ),
                                                        )),
                                                    horizontalTitleGap: 5,
                                                    subtitle: const Text(
                                                      'Antonyms',
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    title: Text(
                                                      _data[0]['meanings'][i]['definitions']
                                                                          [0][
                                                                      'antonyms']
                                                                  [0][0]
                                                              .toUpperCase() +
                                                          _data[0]['meanings']
                                                                          [i][
                                                                      'definitions'][0]
                                                                  ['antonyms'][0]
                                                              .substring(1),
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  )
                                                : Container(),
                                            const SizedBox(height: 20)
                                          ],
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ))
                      : (isFinded == 'processing')
                          ? const SizedBox(
                              height: 200,
                              child: Center(child: RefreshProgressIndicator()))
                          : const SizedBox(
                              height: 300,
                              child: Center(
                                child: Image(
                                  height: 110,
                                  image: AssetImage('assets/img/blank.png'),
                                ),
                              )),
                ],
              ),
            ),
          ),
        ),
        // AvatarGlow(
        //   animate: _isListening,
        //   glowColor: Colors.teal.withOpacity(0.5),
        //   endRadius: 70.0,
        //   duration: const Duration(milliseconds: 800),
        //   repeat: true,
        //   showTwoGlows: true,
        //   repeatPauseDuration: const Duration(milliseconds: 100),
        //   child: ElevatedButton.icon(
        //     onPressed: _listen,
        //     style: ElevatedButton.styleFrom(
        //       primary: Colors.teal.withOpacity(0.8),
        //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //       elevation: 8,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(32.0),
        //       ),
        //     ),
        //     icon: const Icon(
        //       Ionicons.mic_outline,
        //       size: 24,
        //       semanticLabel: 'Press and Hold to Speak!',
        //     ),
        //     label: Text('$_micTxt', style: const TextStyle(fontSize: 18)),
        //   ),
        // )
      ],
    );
  }

  String _fecthSynonyms(data) {
    String txt = '';
    data.asMap().forEach((index, e) {
      if (index < 10) txt += e[0].toUpperCase() + e.substring(1) + ', ';
    });
    return txt;
  }
}
