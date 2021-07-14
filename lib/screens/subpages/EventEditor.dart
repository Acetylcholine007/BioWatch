import 'dart:io';

import 'package:bio_watch/components/LoadingDeterminate.dart';
import 'package:bio_watch/models/Account.dart';
import 'package:bio_watch/models/Activity.dart';
import 'package:bio_watch/models/AppTask.dart';
import 'package:bio_watch/models/Enum.dart';
import 'package:bio_watch/models/EventAsset.dart';
import 'package:bio_watch/models/PeopleEvent.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:bio_watch/services/StorageService.dart';
import 'package:bio_watch/shared/ImageManager.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventEditor extends StatefulWidget {
  EventEditor({this.event, this.isNew, this.eventAsset, this.refresh, this.uid});
  final EventAsset eventAsset;
  final PeopleEvent event;
  final bool isNew;
  final Function refresh;
  final String uid;

  @override
  _EventEditorState createState() => _EventEditorState(event, eventAsset);
}

class _EventEditorState extends State<EventEditor> {
  final _formKey = GlobalKey<FormState>();
  final imageManager = ImageManager();
  EventAsset eventAsset = EventAsset();
  PeopleEvent event;
  bool loading = false;
  bool eventAssetChanged = false;
  bool eventDataChanged = false;
  List<AppTask> tasks = [];
  int taskLength = 0;
  int taskIndex = 0;

  _EventEditorState(this.event, this.eventAsset);

  void incrementIndex() {
    setState(() => taskIndex++);
  }

  void createTaskList(bool isNew, EventAsset asset) {
    if(isNew) {
      if(eventDataChanged) {
        tasks.add(AppTask(heading: 'Database Writing', content: 'Adding to events'));
        if(eventAssetChanged) {
          tasks.add(AppTask(heading: 'Processing Image', content: 'Uploading images'));
          tasks.add(AppTask(heading: 'Processing Image', content: 'Caching images'));
        }
        tasks.add(AppTask(heading: 'Database Writing', content: 'Adding to myEvents'));
        tasks.add(AppTask(heading: 'Database Writing', content: 'Adding to activities'));
      }
    } else {
      if(eventDataChanged) {
        tasks.add(AppTask(heading: 'Database Writing', content: 'Editing events record'));
        if(eventAssetChanged) {
          tasks.add(AppTask(heading: 'Processing Image', content: 'Uploading images'));
          tasks.add(AppTask(heading: 'Processing Image', content: 'Caching images'));
        }
      }
    }
    taskLength = tasks.length;
  }

  void showAssetPicker(BuildContext context, String title, List<File> collection) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Column(
              children: [
                ListTile(
                  title: Text(title, style: theme.textTheme.headline6.copyWith(color: Colors.white)),
                  tileColor: theme.primaryColor,
                ),
                LimitedBox(
                  maxHeight: 400,
                  child: GridView.count(
                    padding: EdgeInsets.all(10),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 3,
                    children: (collection.length < 6 ? <Card>[Card(child: GestureDetector(
                      onTap: () async {
                        dynamic result = await imageManager.showPicker(context);
                        if(result['image'] != null) {
                          setState(() {
                            collection.add(result['image']);
                            eventAssetChanged = true;
                            eventDataChanged = true;
                          });
                          setModalState((){});
                        }
                      },
                      child: Icon(Icons.add, size: 36))
                    )] : <Card>[]) + collection.map((showcase) => Card(child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: Image(image: FileImage(showcase), fit: BoxFit.cover)),
                            ],
                          ),
                          IconButton(icon: Icon(Icons.remove_circle_rounded, color: theme.accentColor), onPressed: (){
                            setState(() {
                              collection.remove(showcase);
                              eventAssetChanged = true;
                              eventDataChanged = true;
                            });
                            setModalState((){});
                          })
                        ]
                      ),
                    ))).toList(),
                  ),
                )
              ],
            );
          },
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = Provider.of<Account>(context);
    final DatabaseService _database = DatabaseService(uid: user.uid);
    final StorageService _storage = StorageService();

    void saveChanges() async {
      if(_formKey.currentState.validate()) {
        setState(() => loading = true);
        event.bannerUri = eventAsset.banner != null ? eventAsset.banner.path.split('/').last : '';
        event.permitUris = eventAsset.permits.isNotEmpty ? eventAsset.permits.map((permit) => permit.path.split('/').last).toList() : [];
        event.showcaseUris = eventAsset.showcases.isNotEmpty ? eventAsset.showcases.map((showcase) => showcase.path.split('/').last).toList() : [];
        createTaskList(widget.isNew, eventAsset);
        if(widget.isNew) {
          String eventId = await _database.createEvent(event);
          incrementIndex();
          if(eventAssetChanged) {
            await _storage.uploadEventAsset(eventId, eventAsset.banner, eventAsset.showcases, eventAsset.permits);
            incrementIndex();
            await imageManager.saveEventAssetToCache(widget.uid, eventId, eventAsset);
            incrementIndex();
          }
          await _database.addToMyEvents(eventId);
          incrementIndex();
          await _database.createActivity(Activity(
            heading: 'Event Created',
            datetime: DateTime.now().toString(),
            body: 'You\'ve created ${event.eventName}',
            type: ActivityType.createEvent
          ));
          final snackBar = SnackBar(
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            content: Text('Event Created'),
            action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          String eventId = eventDataChanged ? await _database.editEvent(event, Activity(
            heading: 'Event Edited',
            datetime: DateTime.now().toString(),
            body: 'You\'ve edited ${event.eventName}',
            type: ActivityType.editEvent
          )) : event.eventId;
          if(eventAssetChanged) {
            incrementIndex();
            await _storage.uploadEventAsset(eventId, eventAsset.banner, eventAsset.showcases, eventAsset.permits);
            incrementIndex();
            await imageManager.saveEventAssetToCache(widget.uid, eventId, eventAsset);
          }
          widget.refresh();
          final snackBar = SnackBar(
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            content: Text('Event Edited'),
            action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
          );
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        Navigator.of(context).pop();
      } else {
        final snackBar = SnackBar(
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Text('Fill up all the fields'),
          action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return loading ? LoadingDeterminate(tasks[taskIndex < taskLength ? taskIndex : taskLength - 1], taskIndex, taskLength) : GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Event Editor'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: eventAssetChanged || eventDataChanged ? () async {
              return showDialog(context: context, builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Edit Event'),
                  content: Text('Do you want to save your changes?'),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.of(context).pop();
                      saveChanges();
                    }, child: Text('Yes')),
                    TextButton(onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }, child: Text('No'))
                  ],
                );
              });
            } : () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(icon: Icon(Icons.save_rounded), onPressed: saveChanges),
          ],
        ),
        body: Builder(
          builder: (context) {
            return SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/subBackground.png'),
                    fit: BoxFit.cover
                  )
                ),
                child: Form(
                  key: _formKey,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: <Widget>[
                              Positioned.fill(
                                child: GestureDetector(
                                  onTap: () async {
                                    dynamic result = await imageManager.showPicker(context);
                                    if(result['image'] != null) {
                                      if(eventAsset.banner != null)
                                        await eventAsset.banner.delete();
                                      setState(() {
                                        eventAsset.banner = result['image'];
                                        eventAssetChanged = true;
                                        eventDataChanged = true;
                                      });
                                    }
                                  },
                                  child: eventAsset.banner != null ? Image(image: FileImage(eventAsset.banner), fit: BoxFit.cover) :
                                  Image(image: AssetImage('assets/placeholder.jpg'), fit: BoxFit.cover)
                                ),
                              ),
                              Positioned(left: 0, bottom: 0, child: ClipRRect(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(5)),
                                child: Container(color: Colors.grey[200], padding: EdgeInsets.all(10), child: Text('Event Banner'))
                              ))
                            ] + (eventAsset.banner != null ? [
                            IconButton(icon: Icon(Icons.remove_circle_rounded, color: theme.accentColor), onPressed: () async {
                              if(eventAsset.banner != null)
                                await eventAsset.banner.delete();
                              setState(() {
                                eventAsset.banner = null;
                                event.bannerUri = '';
                                eventDataChanged = true;
                              });
                            })
                            ] : []),
                          ),
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
                                    onChanged: (val) => setState(() {
                                      event.eventName = val;
                                      eventDataChanged = true;
                                    })
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    initialValue: event.address,
                                    decoration: textFieldDecoration.copyWith(hintText: 'Event Address'),
                                    validator: (val) => val.isEmpty ? 'Enter Event Address' : null,
                                    onChanged: (val) => setState(() {
                                      event.address = val;
                                      eventDataChanged = true;
                                    })
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    initialValue: event.description,
                                    decoration: textFieldDecoration.copyWith(hintText: 'Event Description'),
                                    validator: (val) => val.isEmpty ? 'Enter Event Description' : null,
                                    onChanged: (val) => setState(() {
                                      event.description = val;
                                      eventDataChanged = true;
                                    }),
                                    maxLines: 5,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: DateTimePicker(
                                    type: DateTimePickerType.dateTime,
                                    dateMask: 'MMMM dd, yyyy hh:mm a',
                                    initialValue: event.datetime.toString(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(DateTime.now().year + 5),
                                    icon: Icon(Icons.event),
                                    dateLabelText: 'Date',
                                    timeLabelText: 'Time',
                                    onChanged: (val) => setState(() {
                                      event.datetime = DateTime.parse(val);
                                      eventDataChanged = true;
                                      print(val);
                                    }),
                                    decoration: textFieldDecoration.copyWith(hintText: 'Date and Time'),
                                    use24HourFormat: false,
                                    validator: (val) => val.isEmpty ? 'Enter Event Date and Time' : null,
                                  )
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Card(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(5),
                                            child: Stack(
                                              alignment: AlignmentDirectional.bottomStart,
                                              children: [
                                                Positioned.fill(
                                                  child: GestureDetector(
                                                    onTap: () => showAssetPicker(context, 'Showcase Collection', eventAsset.showcases),
                                                    child: eventAsset.showcases.isNotEmpty ? Image(image: FileImage(eventAsset.showcases[0]), fit: BoxFit.cover) :
                                                    Image(image: AssetImage('assets/placeholder.jpg'), fit: BoxFit.cover)
                                                  ),
                                                ),
                                                ClipRRect(borderRadius: BorderRadius.only(topRight: Radius.circular(5)), child: Container(color: Colors.grey[200], padding: EdgeInsets.all(10), child: Text('Showcases')))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Card(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(5),
                                            child: Stack(
                                              alignment: AlignmentDirectional.bottomStart,
                                              children: [
                                                Positioned.fill(
                                                  child: GestureDetector(
                                                    onTap: () => showAssetPicker(context, 'Permit Collection', eventAsset.permits),
                                                    child: eventAsset.permits.isNotEmpty ? Image(image: FileImage(eventAsset.permits[0]), fit: BoxFit.cover) :
                                                    Image(image: AssetImage('assets/placeholder.jpg'), fit: BoxFit.cover)
                                                  ),
                                                ),
                                                ClipRRect(borderRadius: BorderRadius.only(topRight: Radius.circular(5)), child: Container(color: Colors.grey[200], padding: EdgeInsets.all(10), child: Text('Permits')))
                                              ],
                                            ),
                                          ),
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
        ),
      ),
    );
  }
}
