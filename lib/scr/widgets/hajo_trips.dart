import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/scr/provider/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoggedInWidget extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final uri = 'https://localhost:3000/book_ride/';
    var map = new Map<String, dynamic>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'name',
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: 'From is required'),
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'email',
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: 'Email is required'),
                        FormBuilderValidators.email(context,
                            errorText: "Invalid email"),
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'phone',
                      decoration: const InputDecoration(labelText: 'Phone'),
                      keyboardType: TextInputType.number,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: 'Phone is required'),
                        FormBuilderValidators.numeric(context,
                            errorText: "Invalid phone"),
                        FormBuilderValidators.minLength(context, 10,
                            errorText: "Invalid phone"),
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'from',
                      decoration: const InputDecoration(labelText: 'From'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: 'From is required'),
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'to',
                      decoration: const InputDecoration(labelText: 'To'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: 'To is required'),
                      ]),
                    ),
                    FormBuilderDateTimePicker(
                      name: 'dep',
                      decoration: const InputDecoration(
                          labelText: 'Departure Date and Time'),
                      inputType: InputType.both,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: 'Departure Date and Time is required'),
                        (value) {
                          if (value!.isBefore(DateTime.now())) {
                            return 'Departure Date and Time must be after current time';
                          }
                        }
                      ]),
                    ),
                    FormBuilderChoiceChip(
                      name: 'vehicle',
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Type',
                      ),
                      options: const [
                        FormBuilderFieldOption(
                            value: 'hajo_vehicle',
                            child: Text('🚕 HaJo Vehicle')),
                        FormBuilderFieldOption(
                            value: 'own_vehicle',
                            child: Text('🚙 Own Vehicle')),
                      ],
                      validator: FormBuilderValidators.required(context,
                          errorText: 'This Field is required'),
                    ),
                    FormBuilderFilterChip(
                      name: 'interests',
                      decoration: const InputDecoration(
                        labelText: 'Interests',
                      ),
                      options: const [
                        FormBuilderFieldOption(
                          value: 'temples',
                          child: Text('🛕 Temples'),
                        ),
                        FormBuilderFieldOption(
                          value: 'historical_places',
                          child: Text('🏛 Historical Places'),
                        ),
                        FormBuilderFieldOption(
                          value: 'water_bodies',
                          child: Text('🌊 Water Bodies'),
                        ),
                        FormBuilderFieldOption(
                          value: 'museums',
                          child: Text('🕍 Museums'),
                        ),
                        FormBuilderFieldOption(
                          value: 'national_parks',
                          child: Text('🌲 National Parks'),
                        ),
                        FormBuilderFieldOption(
                          value: 'galleries',
                          child: Text('🖼 Galleries'),
                        ),
                        FormBuilderFieldOption(
                          value: 'adventure',
                          child: Text('🚵‍♀️ Adventure/Trekking'),
                        ),
                      ],
                      validator: (value) {
                        if (value?.length == 0) {
                          return 'Please select at least one interest';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _formKey.currentState!.save();
                        if (_formKey.currentState!.validate()) {
                          map['name'] = _formKey.currentState!.value['name'];
                          map['email'] = _formKey.currentState!.value['email'];
                          map['phone'] = _formKey.currentState!.value['phone'];
                          map['from'] = _formKey.currentState!.value['from'];
                          map['to'] = _formKey.currentState!.value['to'];
                          map['dep'] = DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(_formKey.currentState!.value['dep']);
                          map['vehicle'] =
                              _formKey.currentState!.value['vehicle'];
                          map['interests'] =
                              _formKey.currentState!.value['interests'];

                          http
                              .post(Uri.parse('http://10.0.2.2:3000/book_trip'),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  },
                                  body: jsonEncode(<String, dynamic>{
                                    'name': map['name'],
                                    'email': map['email'],
                                    'phone': map['phone'],
                                    'from': map['from'],
                                    'to': map['to'],
                                    'vehicle': map['vehicle'],
                                    'int': map['interests'].toString(),
                                    'dep': map['dep']
                                  }))
                              .then((response) {
                            print(response.statusCode);
                            _formKey.currentState!.reset();
                            SnackBar snackBar = const SnackBar(
                              content: Text(
                                  'Your Trip has been booked. Please check your email in 24Hrs for confirmation'),
                              duration: Duration(seconds: 5),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                        FocusScope.of(context).unfocus();
                      },
                      child: const Text('Reset'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
