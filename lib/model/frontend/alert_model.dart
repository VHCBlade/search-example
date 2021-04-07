import 'package:flutter/material.dart';
import 'package:search_example/events/event_names.dart';
import 'package:search_example/state/event_channel.dart';
import 'package:search_example/state/model.dart';

class AlertData {
  final String name;
  final String info;

  AlertData({required this.name, required this.info});
}

class AlertModel with Model {
  final ProviderEventChannel eventChannel;
  BuildContext? buildContext;

  AlertModel({ProviderEventChannel? parentChannel, required this.buildContext})
      : eventChannel = new ProviderEventChannel(parentChannel) {
    eventChannel.addEventListener(ERROR_ALERT_EVENT, (val) {
      final AlertData data = val;
      if (buildContext != null) {
        showDialog(
            builder: (context) => AlertDialog(
                    title: Text(data.name),
                    content: Text(data.info),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("OK"),
                      )
                    ]),
            context: buildContext!);
      } else {
        assert(buildContext != null);
      }
      return true;
    });

    eventChannel.addEventListener(CONTEXT_EVENT, (val) {
      buildContext = val;
      return false;
    });
  }
}
