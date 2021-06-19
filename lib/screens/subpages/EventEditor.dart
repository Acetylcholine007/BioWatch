import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/models/Account.dart';
import 'package:bio_watch/models/Activity.dart';
import 'package:bio_watch/models/EventAsset.dart';
import 'package:bio_watch/models/EventImage.dart';
import 'package:bio_watch/models/PeopleEvent.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:bio_watch/services/StorageService.dart';
import 'package:bio_watch/shared/ImageManager.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventEditor extends StatefulWidget {
  EventEditor({this.event, this.isNew, this.eventImage, this.refresh});
  final EventImage eventImage;
  final PeopleEvent event;
  final bool isNew;
  final Function refresh;

  @override
  _EventEditorState createState() => _EventEditorState(event);
}

class _EventEditorState extends State<EventEditor> {
  final _formKey = GlobalKey<FormState>();
  final imagePicker = ImageManager();
  EventAsset eventAsset = EventAsset();
  PeopleEvent event;
  bool loading = false;

  _EventEditorState(this.event);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Account>(context);
    final DatabaseService _database = DatabaseService(uid: user.uid);
    final StorageService _storage = StorageService();

    return loading ? Loading() : GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Event Editor'),
          actions: [
            IconButton(icon: Icon(Icons.save_rounded), onPressed: () async {
              if(_formKey.currentState.validate()) {
                setState(() => loading = true);
                event.bannerUri = eventAsset.banner.path.split('/').last;
                event.permitUris = eventAsset.permits.map((permit) => permit.path.split('/').last).toList();
                event.showcaseUris = eventAsset.showcases.map((showcase) => showcase.path.split('/').last).toList();
                if(widget.isNew) {
                  String eventId = await _database.createEvent(event, Activity(
                    heading: 'Event Created',
                    time: TimeOfDay.now().format(context).split(' ')[0],
                    date: DateTime.now().toString(),
                    body: 'You\'ve created ${event.eventName}'
                  ));
                  await _storage.uploadEventAsset(eventId, eventAsset.banner, eventAsset.showcases, eventAsset.permits);
                } else {
                  String eventId = await _database.editEvent(event, Activity(
                    heading: 'Event Edited',
                    time: TimeOfDay.now().format(context).split(' ')[0],
                    date: DateTime.now().toString(),
                    body: 'You\'ve edited ${event.eventName}'
                  ));
                  await _storage.uploadEventAsset(eventId, eventAsset.banner, eventAsset.showcases, eventAsset.permits);
                }
                widget.refresh();
                Navigator.of(context).pop();
                //TODO: Check for success or failure and update loading state
              }
            }),
          ],
        ),
        body: Container(
          child: Form(
            key: _formKey,
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
                                  onTap: () async {
                                    dynamic result = await imagePicker.showPicker(context);
                                    if(result['image'] != null) {
                                      if(eventAsset.showcases.isNotEmpty)
                                        await eventAsset.showcases.removeAt(0).delete();
                                      setState(() {
                                        eventAsset.showcases.add(result['image']);
                                      });
                                    }
                                  },
                                  child: eventAsset.showcases.isNotEmpty ? Image(image: FileImage(eventAsset.showcases[0]), fit: BoxFit.fitHeight) :
                                    widget.eventImage.showcases.isNotEmpty ? widget.eventImage.showcases[0] : Image(image: AssetImage(event.bannerUri), fit: BoxFit.fitHeight)
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    dynamic result = await imagePicker.showPicker(context);
                                    if(result['image'] != null) {
                                      if(eventAsset.permits.isNotEmpty)
                                        await eventAsset.permits.removeAt(0).delete();
                                      setState(() {
                                        eventAsset.permits.add(result['image']);
                                      });
                                    }
                                  },
                                  child: eventAsset.permits.isNotEmpty ? Image(image: FileImage(eventAsset.permits[0]), fit: BoxFit.fitHeight) :
                                    widget.eventImage.permits.isNotEmpty ? widget.eventImage.permits[0] : Image(image: AssetImage(event.bannerUri), fit: BoxFit.fitHeight)
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
