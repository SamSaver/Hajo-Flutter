import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class HajoRides extends StatelessWidget {
  final _ridesKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final uri = 'https://localhost:3000/book_ride/';
    var map = new Map<String, dynamic>();

    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              FormBuilder(
                  key: _ridesKey,
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
                              errorText: "Invalid phone number"),
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
                        decoration: const InputDecoration(labelText: 'to'),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: 'To is required'),
                        ]),
                      ),
                      FormBuilderDateTimePicker(
                        name: 'departure_date_time',
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
                              value: 'car', child: Text('🚙 Car')),
                          FormBuilderFieldOption(
                              value: 'auto', child: Text('🚙 Auto')),
                        ],
                        validator: FormBuilderValidators.required(context,
                            errorText: 'This Field is required'),
                      ),
                      FormBuilderChoiceChip(
                        name: 'has_group',
                        decoration: const InputDecoration(
                          labelText: 'Has Group',
                        ),
                        options: const [
                          FormBuilderFieldOption(
                              value: 'Yes', child: Text('✅ Yes')),
                          FormBuilderFieldOption(
                              value: 'No', child: Text('🚫 No')),
                        ],
                        validator: FormBuilderValidators.required(context,
                            errorText: 'This Field is required'),
                      ),
                      FormBuilderTextField(
                        name: 'group_size',
                        decoration:
                            const InputDecoration(labelText: 'Group Size'),
                        keyboardType: TextInputType.number,
                      ),
                      FormBuilderChoiceChip(
                        name: 'share_rides',
                        decoration: const InputDecoration(
                          labelText: 'Share Rides',
                        ),
                        options: const [
                          FormBuilderFieldOption(
                              value: 'Yes', child: Text('✅ Yes')),
                          FormBuilderFieldOption(
                              value: 'No', child: Text('🚫 No')),
                        ],
                        validator: FormBuilderValidators.required(context,
                            errorText: 'This Field is required'),
                      ),
                    ],
                  )),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _ridesKey.currentState!.save();
                        if (_ridesKey.currentState!.validate()) {
                          map['name'] = _ridesKey.currentState!.value['name'];
                          map['email'] = _ridesKey.currentState!.value['email'];
                          map['phone'] = _ridesKey.currentState!.value['phone'];
                          map['from'] = _ridesKey.currentState!.value['from'];
                          map['to'] = _ridesKey.currentState!.value['to'];
                          map['departure_date_time'] =
                              DateFormat('yyyy-MM-dd HH:mm:ss').format(_ridesKey
                                  .currentState!.value['departure_date_time']);
                          map['vehicle'] =
                              _ridesKey.currentState!.value['vehicle'];
                          map['has_group'] =
                              _ridesKey.currentState!.value['has_group'];
                          map['group_size'] =
                              _ridesKey.currentState!.value['group_size'];
                          map['share_rides'] =
                              _ridesKey.currentState!.value['share_rides'];

                          http
                              .post(Uri.parse('http://10.0.2.2:3000/book_ride'),
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
                                    'hasGroup': map['has_group'],
                                    'groupSize': map['group_size'],
                                    'shareRides': map['share_rides'],
                                    'dep': map['departure_date_time']
                                  }))
                              .then((response) {
                            print(response.statusCode);
                            _ridesKey.currentState!.reset();
                            SnackBar snackBar = const SnackBar(
                              content: Text(
                                  'Your Ride has been booked. Please check your email in 24Hrs for confirmation'),
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
                        _ridesKey.currentState!.reset();
                        FocusScope.of(context).unfocus();
                      },
                      child: const Text('Reset'),
                    ),
                  ),
                ],
              )
            ],
          )),
    ));
  }
}
