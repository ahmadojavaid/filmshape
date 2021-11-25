import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'AppColors.dart';
import 'Constants/AppCustomTheme.dart';
import 'Constants/Const.dart';

typedef void OnTapCallback(String value);

class AutoCompleteTextView extends StatefulWidget
    with AutoCompleteTextInterface {
  final double maxHeight;
  final TextEditingController controller;

  //AutoCompleteTextField properties
  final tfCursorColor;
  final tfCursorWidth;
  final tfStyle;
  final tfTextDecoration;
  final tfTextAlign;
  //Suggestiondrop Down properties
  final suggestionStyle;
  final suggestionTextAlign;
  final onTapCallback;
  final Function getSuggestionsMethod;
  final Function focusGained;
  final Function focusLost;
  final int suggestionsApiFetchDelay;
  final Function onValueChanged;
  final String hintText;
  final IconData icon;
  final bool isLocation;
  final double defaultPadding;

  AutoCompleteTextView({
    this.isLocation,
    this.hintText,
        @required this.controller,
        this.onTapCallback,
        this.maxHeight = 200,
        this.tfCursorColor = Colors.blue,
        this.tfCursorWidth = 2.0,
        this.tfStyle = AppCustomTheme.ediTextStyle,
        this.tfTextDecoration = const InputDecoration(),
        this.tfTextAlign = TextAlign.left,
        this.suggestionStyle =  AppCustomTheme.ediTextStyle,
        this.suggestionTextAlign = TextAlign.left,
        @required this.getSuggestionsMethod,
        this.focusGained,
        this.suggestionsApiFetchDelay = 0,
        this.focusLost,
        this.onValueChanged,
        this.icon,
        this.defaultPadding
      });
  @override
  _AutoCompleteTextViewState createState() => _AutoCompleteTextViewState();

  //This funciton is called when a user clicks on a suggestion
  @override
  void onTappedSuggestion(String suggestion) {
    onTapCallback(suggestion);
  }
}

class _AutoCompleteTextViewState extends State<AutoCompleteTextView> {
  ScrollController scrollController = ScrollController();
  FocusNode _focusNode = FocusNode();
  OverlayEntry _overlayEntry;
  LayerLink _layerLink = LayerLink();
  final suggestionsStreamController = new BehaviorSubject<List<String>>();
  List<String> suggestionShowList = List<String>();
  Timer _debounce;
  bool isSearching = true;
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);
        (widget.focusGained != null) ? widget.focusGained() : () {};
      } else {
        this._overlayEntry.remove();
        (widget.focusLost != null) ? widget.focusLost() : () {};
      }
    });
    widget.controller.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce =
        Timer(Duration(milliseconds: widget.suggestionsApiFetchDelay), () {
          if (isSearching == true) {
            _getSuggestions(widget.controller.text);
          }
        });
  }

  _getSuggestions(String data) async {
    if (data.length > 0 && data != null) {
      List<String> list = await widget.getSuggestionsMethod(data);
      suggestionsStreamController.sink.add(list);
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    return OverlayEntry(
        builder: (context) => Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: this._layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 5.0),
            child: Material(
              elevation: 4.0,
              child: StreamBuilder<Object>(
                  stream: suggestionsStreamController.stream,
                  builder: (context, suggestionData) {
                    if (suggestionData.hasData &&
                        widget.controller.text.isNotEmpty) {
                      suggestionShowList = suggestionData.data;
                      return ConstrainedBox(
                        constraints: new BoxConstraints(
                          maxHeight: 200,
                        ),
                        child: ListView.builder(
                            controller: scrollController,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: suggestionShowList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  suggestionShowList[index],
                                  style: widget.tfStyle,
                                  textAlign: widget.suggestionTextAlign,
                                ),
                                onTap: () {
                                  isSearching = false;
                                  if (widget.isLocation) {
                                    widget.controller.text =
                                    suggestionShowList[index];
                                  }
                                  else {
                                    widget.controller.text = "";
                                  }

                                  suggestionsStreamController.sink.add([]);
                                  widget.onTappedSuggestion(
                                      suggestionShowList[index]);


                                },
                              );
                            }),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: TextField(
        controller: widget.controller,
        style: widget.tfStyle,
        cursorColor: widget.tfCursorColor,
        cursorWidth: widget.tfCursorWidth,
        textAlign: widget.tfTextAlign,
        focusNode: this._focusNode,


        onChanged: (text) {
          if (text.trim().isNotEmpty) {
            (widget.onValueChanged != null)
                ? widget.onValueChanged(text)
                : () {};
            isSearching = true;
            scrollController.animateTo(
              0.0,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            );
          } else {
            isSearching = false;
            suggestionsStreamController.sink.add([]);
          }
        },
          decoration: new InputDecoration(

            border: new OutlineInputBorder(),
                 contentPadding: new EdgeInsets.symmetric(
                    vertical: TextFormField_Veritical_Margin,
                    horizontal: TextFormField_Horizontal_Margin),
            labelText: widget.hintText,

            prefixIcon: (widget.icon!=null)?Padding(
              padding:  EdgeInsets.only(left:widget.defaultPadding),
              child: Icon(widget.icon,color: Colors.black,),
            ):null,
            labelStyle: AppCustomTheme.labelEdiTextRegular,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: INPUT_BOX_BORDER_WIDTH),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: AppColors.creatreProfileBordercolor, width: INPUT_BOX_BORDER_WIDTH),
            ),)
      ),
    );
  }

  @override
  void dispose() {
    suggestionsStreamController.close();
    scrollController.dispose();
    widget.controller.dispose();
    super.dispose();
  }
}

abstract class AutoCompleteTextInterface {
  void onTappedSuggestion(String suggestion);
}