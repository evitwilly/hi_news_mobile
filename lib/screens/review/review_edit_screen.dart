import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_news/data/repository.dart';
import 'package:hi_news/domain/review.dart';
import 'package:hi_news/helpers/utils.dart';
import 'package:hi_news/resources/strings.dart';
import 'package:hi_news/screens/about/widgets/rating_bar_widget.dart';
import 'package:hi_news/widgets/leading_icon.dart';
import 'package:hi_news/widgets/my_elevated_button.dart';

class ReviewEditScreen extends StatefulWidget {
  @override
  _ReviewEditScreenState createState() => _ReviewEditScreenState();
}

class _ReviewEditScreenState extends State<ReviewEditScreen> {

  final Repository repository = new Repository();
  final TextEditingController _controllerName = new TextEditingController();
  final TextEditingController _controllerReview = new TextEditingController();
  final GlobalKey<FormState> _key = new GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double rating = 0.0;
  bool isRatingError = false;
  bool isDisabledSendButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(Strings.newReview),
        leading: LeadingIcon(),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildRatingName(),
        _buildRating(),
        isRatingError ? _buildRatingError() : Container(),
        _buildForm(),
      ],
    );
  }

  Widget _buildRatingName() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Text(Strings.ratings[rating.toInt()],
          style: TextStyle(fontSize: 16)
      ),
    );
  }

  Widget _buildRating() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: RatingBarWidget(
        rating,
        isReadOnly: false,
        onRated: (rating) {
          setState(() {
            this.rating = rating;
          });
        },
        size: 36,
        spacing: 7,
      ),
    );
  }

  Widget _buildRatingError() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        Strings.ratingShouldNotZero,
        style: TextStyle(color: Colors.red, fontSize: 13),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
      child: Form(
        key: _key,
        child: SingleChildScrollView(child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildYourName(),
            _buildYourReview(),
            _buildSendButton(),
          ],
        ),
      ),)
    );
  }

  Widget _buildYourName() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: _controllerName,
        decoration: InputDecoration(
          hintText: Strings.yourName,
        ),
        validator: checkFieldEmpty,
      ),
    );
  }

  Widget _buildYourReview() {
    return Container(
      child: TextFormField(
        controller: _controllerReview,
        decoration: InputDecoration(hintText: Strings.yourReview),
        validator: checkFieldEmpty,
      ),
    );
  }

  Widget _buildSendButton() {
    return Container(
        margin: EdgeInsets.only(left: 40, right: 40, top: 30),
        child: MyElevatedButton(
          Strings.send,
          isDisabledSendButton ? null : _acceptReview,
          padding: EdgeInsets.only(top: 13, bottom: 13),
        )
    );
  }

  void _acceptReview() async {
    _toggleDisabledSendButton();
    if (!_key.currentState.validate()) {
      _toggleDisabledSendButton();
      return;
    }
    if (rating == 0.0) {
      setState(() {
        isRatingError = true;
      });
      _toggleDisabledSendButton();
      return;
    }
    try {

      final review = Review(
        _controllerName.text,
        getDateNow(),
        rating,
        _controllerReview.text,
      );
      await repository.saveReview(review);
      _showDialog();

    } catch (error) {
      _showError();
    }
    _toggleDisabledSendButton();
  }

  void _showError() {
    final snackBar = SnackBar(
      content: Text(Strings.reviewAddingFailed),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _showDialog() {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(Strings.thankYouReview, textAlign: TextAlign.center,),
              ),
              Container(
                height: 30,
                child: MyElevatedButton(Strings.ok, () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ),
            ],
          )
      );
    }).then((value) {
      if (value) Navigator.of(context).pop();
    });
  }

  void _toggleDisabledSendButton() {
    setState(() {
      isDisabledSendButton = !isDisabledSendButton;
    });
  }
}
