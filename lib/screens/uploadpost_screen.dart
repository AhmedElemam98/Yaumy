import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yaumyapp/providers/posts.dart';
import 'package:yaumyapp/utilities/dialog_error.dart';
import '../utilities/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../providers/user.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/progress_indecator.dart';

class UploadPostScreen extends StatefulWidget {
  @override
  _UploadPostScreenState createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  File _image;
  final _form = GlobalKey<FormState>();
  final _locationFocusNode = FocusNode();
  final _locationController = TextEditingController();
  String _description;
  String _location;
  BuildContext _context;
  bool _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      final a=Provider.of<Posts>(context,listen: false);
      await a.fetchAndSetPosts();
      List posts=a.posts;
      print(posts[0].id);

    });
    super.initState();
  }

  @override
  void dispose() {
    _locationFocusNode.dispose();
    _locationController.dispose();
    super.dispose();
  }

  getUserLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await Geolocator()
          .placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark placemark = placemarks[0];
      String formattedAddress = "${placemark.locality}, ${placemark.country}";
      _locationController.text = formattedAddress;
    } catch (e) {
      showErrorDialog(
          context: _context,
          errorMessage:
              'Please,Enable location permission to access your location');
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Posts>(context, listen: false)
            .addPost(_image, _description, _location);
      } catch (error) {
        showErrorDialog(
            context: _context,
            errorMessage: 'some thing went wrong,Try Again later!');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleImage(ImageSource imgSrc) async {
    Navigator.pop(_context);
    //Pick the img
    final future = ImagePicker.pickImage(
        source: imgSrc, imageQuality: 85, maxHeight: 675, maxWidth: 960);
    File pickedImg = await future;
    //Edit the img
    File croppedImg = await ImageCropper.cropImage(
        sourcePath: pickedImg.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Edit Image',
            toolbarColor: Color(0XFF61045f),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      _image = croppedImg;
    });
  }

  _selectImage(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text('create post'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Photo with camera'),
                onPressed: () => _handleImage(ImageSource.camera),
              ),
              SimpleDialogOption(
                child: Text('Image from gallery'),
                onPressed: () => _handleImage(ImageSource.gallery),
              ),
              SimpleDialogOption(
                child: Text('Cancle'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  void _clearImage() {
    setState(() {
      _image = null;
      _locationController.text = '';
    });
  }

  Widget _createPost(String photoUrl) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF61045f),
        centerTitle: true,
        title: Text(
          'share Post',
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: _clearImage,
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: _isLoading ? null : _saveForm,
            child: Text(
              'post',
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white30,
        child: Form(
          key: _form,
          child: ListView(
            padding: EdgeInsets.all(8),
            children: <Widget>[
              _isLoading ? linearProgress() : Container(),
              Container(
                height: 220,
                width: MediaQuery.of(_context).size.width,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0XFF61045f),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(_image),
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(photoUrl),
                  backgroundColor: Colors.redAccent,
                ),
                title: Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Write a Caption...",
                        border: InputBorder.none),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(_context).requestFocus(_locationFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty)
                        return 'enter a caption';
                      else {
                        if (value.length < 10) return 'caption is too short!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _description = value;
                    },
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.pin_drop,
                  color: Colors.redAccent,
                  size: 35,
                ),
                title: Container(
                  child: TextFormField(
                    focusNode: _locationFocusNode,
                    controller: _locationController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 4)
                        return 'enter a valid location';
                      return null;
                    },
                    onSaved: (value) {
                      _location = value;
                    },
                    decoration: InputDecoration(
                        hintText: "Where was this photo token?...",
                        border: InputBorder.none),
                  ),
                ),
              ),
              Container(
                width: 200,
                height: 100,
                alignment: Alignment.center,
                child: RaisedButton.icon(
                    color: Colors.redAccent,
                    onPressed: () async {
                      Position position = await Geolocator().getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);
                      List<Placemark> placemarks = await Geolocator()
                          .placemarkFromCoordinates(
                              position.latitude, position.longitude);
                      Placemark placemark = placemarks[0];
                      String formattedAddress =
                          "${placemark.locality}, ${placemark.country}";
                      _locationController.text = formattedAddress;
                    },
                    icon: Icon(
                      Icons.my_location,
                      color: Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    label: Text(
                      'Use current location',
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context).currentUser;
    _context = context;
    return Scaffold(
      body: _image != null
          ? _createPost(user.photoUrl)
          : Container(
              height: double.infinity,
              width: double.infinity,
              decoration: kBackgroundDecoration,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/logos/upload.svg',
                    height: 260,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    color: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      'upload Image',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    onPressed: () => _selectImage(context),
                  ),
                ],
              ),
            ),
    );
  }
}
