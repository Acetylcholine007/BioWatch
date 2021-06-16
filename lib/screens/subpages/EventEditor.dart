import 'package:bio_watch/models/Account.dart';
import 'package:bio_watch/models/Activity.dart';
import 'package:bio_watch/models/EventAsset.dart';
import 'package:bio_watch/models/EventImage.dart';
import 'package:bio_watch/models/PeopleEvent.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:bio_watch/shared/ImageManager.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventEditor extends StatefulWidget {
  EventEditor({this.event, this.isNew, this.eventImage});
  final EventImage eventImage;
  final PeopleEvent event;
  final bool isNew;

  @override
  _EventEditorState createState() => _EventEditorState(event);
}

class _EventEditorState extends State<EventEditor> {
  final imagePicker = ImageManager();
  EventAsset eventAsset = EventAsset();
  PeopleEvent event;

  _EventEditorState(this.event);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Account>(context);
    final DatabaseService _database = DatabaseService(uid: user.uid);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Event Editor'),
          actions: [
            IconButton(icon: Icon(Icons.save_rounded), onPressed: () {
              if(widget.isNew) {
                _database.createEvent(event, Activity(
                  heading: 'Event Created',
                  time: TimeOfDay.now().format(context).split(' ')[0],
                  date: DateTime.now().toString(),
                  body: 'You\'ve created ${event.eventName}'
                ));
              } else {
                _database.editEvent(event, Activity(
                  heading: 'Event Edited',
                  time: TimeOfDay.now().format(context).split(' ')[0],
                  date: DateTime.now().toString(),
                  body: 'You\'ve edited ${event.eventName}'
                ));
              }
              Navigator.of(context).pop();
            }),
          ],
        ),
        body: Container(
          child: Form(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () async {
                      dynamic result = await imagePicker.showPicker(context);
                      if(result['image'] != null) {
                        if(eventAsset.banner != null)
                          await eventAsset.banner.delete();
                        setState(() {
                          eventAsset.banner = result['image'];
                        });
                      }
                    },
                    child: eventAsset.banner != null ? Image(image: FileImage(eventAsset.banner), fit: BoxFit.fitHeight) :
                      widget.eventImage.banner != null ? widget.eventImage.banner : Image(image: AssetImage(event.bannerUri), fit: BoxFit.fitHeight)
                  )
                ),
                Expanded(
                  flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: event.eventName,
                            decoration: textFieldDecoration.copyWith(hintText: 'Event Name'),
                            validator: (val) => val.isEmpty ? 'Enter Event Name' : null,
                            onChanged: (val) => setState(() => event.eventName = val)
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: event.address,
                            decoration: textFieldDecoration.copyWith(hintText: 'Event Address'),
                            validator: (val) => val.isEmpty ? 'Enter Event Address' : null,
                            onChanged: (val) => setState(() => event.address = val)
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            initialValue: event.description,
                            decoration: textFieldDecoration.copyWith(hintText: 'Event Description'),
                            validator: (val) => val.isEmpty ? 'Enter Event Description' : null,
                            onChanged: (val) => setState(() => event.description = val),
                            maxLines: 3,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(
                                child: DateTimePicker(
                                  type: DateTimePickerType.date,
                                  dateMask: 'MMMM d, yyyy',
                                  initialValue: event.date,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(DateTime.now().year + 5),
                                  dateLabelText: 'Date',
                                  decoration: textFieldDecoration.copyWith(suffixIcon: Icon(Icons.date_range_rounded)),
                                  onChanged: (val) => setState(() => event.date = val),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: DateTimePicker(
                                  type: DateTimePickerType.time,
                                  initialValue: event.time,
                                  timeLabelText: "Hour",
                                  decoration: textFieldDecoration.copyWith(suffixIcon: Icon(Icons.access_time_rounded)),
                                  onChanged: (val) => setState(() => event.time = val),
                                ),
                              ),
                            ],
                          )
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Placeholder()
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Placeholder(),
                                )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
