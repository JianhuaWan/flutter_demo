import 'package:flutter/material.dart';
import 'package:flutter_app/view/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';

class TextEditWidget extends StatefulWidget {
  final String hint;
  final Function(String) onSubmitted;
  final Color bgColor;
  final TextEditingController textCon;

  const TextEditWidget({
    Key key,
    this.hint,
    this.onSubmitted,
    this.bgColor = const Color(0x10000000),
    this.textCon,
  }) : super(key: key);

  @override
  _TextEditWidgetState createState() => _TextEditWidgetState();
}

class _TextEditWidgetState extends State<TextEditWidget> {
  TextEditingController textCon = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 40,
      duration: Duration(milliseconds: 200),
      padding: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.black.withOpacity(focusNode.hasFocus ? 0.25 : 0.0),
        ),
      ),
      margin: EdgeInsets.all(12),
      child: Row(
        children: [
          buildTFView(
            context,
            hintText: widget.hint ?? '请输入变电站名',
            isExp: true,
            focusNode: focusNode,
            onChanged: (v) => setState(() {}),
            con: widget.textCon ?? textCon,
            textInputAction: TextInputAction.search,
            onSubmitted: (v) => widget.onSubmitted(v),
          ),
          WidgetTap(
            isElastic: textCon.text != '',
            onTap: () {
              if (textCon.text != '') {
                setState(() => textCon.clear());
                FocusScope.of(context).requestFocus(FocusNode());
                widget.onSubmitted(textCon.text);
              }
            },
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 100),
              opacity: textCon.text == '' ? 0.0 : 1.0,
              child: Container(width: 40, height: 40, child: Icon(Icons.clear_rounded, size: 20)),
            ),
          ),
          WidgetTap(
            isElastic: textCon.text != '',
            onTap: () {
              if (textCon.text != '') {
                FocusScope.of(context).requestFocus(FocusNode());
                widget.onSubmitted(textCon.text);
              }
            },
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 100),
              opacity: textCon.text == '' ? 0.25 : 1.0,
              child: Container(width: 40, height: 40, child: Icon(Icons.search, size: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
