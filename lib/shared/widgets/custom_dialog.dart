import 'dart:ui';

import 'package:flutter/material.dart';

///
class CustomDialog extends StatelessWidget {
  ///
  const CustomDialog(
      {required this.onPressed,
      this.title,
      this.image,
      this.description,
      this.body,
      this.details,
      this.height = 528,
      this.buttonLabel = 'OKAY',
      this.padding = const EdgeInsets.only(top: 82),
      this.titlePadding = EdgeInsets.zero,
      this.bottomPadding = EdgeInsets.zero});

  final String? title;
  final Widget? image;
  final Widget? description;
  final Widget? body;
  final Widget? details;
  final double height;
  final String buttonLabel;
  final Function() onPressed;
  final EdgeInsets padding;
  final EdgeInsets titlePadding;
  final EdgeInsets bottomPadding;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Dialog(
            insetPadding: const EdgeInsets.only(left: 20, right: 20),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    image ?? Container(),
                    Container(
                        margin: image == null
                            ? padding
                            : const EdgeInsets.symmetric(horizontal: 8),
                        child: title != null
                            ? Padding(
                                padding: titlePadding,
                                child: Text(title!,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                            color: Colors.black, fontSize: 24)),
                              )
                            : Container()),
                    description ?? Container(),
                    body ?? Container(),
                    details ?? Container(),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 24, right: 24),
                      child: Padding(
                        padding: bottomPadding,
                        child: ElevatedButton(
                            onPressed: onPressed,
                            child: Text(buttonLabel,
                                style:
                                    Theme.of(context).textTheme.labelLarge!)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
