import 'package:flutter/material.dart';
import 'package:solidarius/pages/quest/request_page.dart';
import 'package:solidarius/shared/datas/request_data.dart';
import 'package:solidarius/shared/models/user_model.dart';
import 'package:solidarius/shared/repositories/request_repository.dart';
import 'package:solidarius/shared/util/constants.dart';

class RequestFormPage extends StatefulWidget {
  final UserModel model;

  const RequestFormPage(this.model, {Key? key}) : super(key: key);

  @override
  _RequestFormPageState createState() => _RequestFormPageState();
}

class _RequestFormPageState extends State<RequestFormPage> {
  int _currentStep = 0;
  bool _isRequestFormValid = false;
  RequestData _editedRequest = new RequestData();

  final GlobalKey<FormState> _requestDataFormkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _personalDataFormKey = GlobalKey<FormState>();

  final TextEditingController _pixController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _requesterController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          "Pedido de auxílio",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      floatingActionButton: Visibility(
        visible: _isRequestFormValid,
        child: FloatingActionButton(
          onPressed: _checkButtonPress,
          child: Icon(
            Icons.check,
            color: Theme.of(context).primaryColor,
          ),
          backgroundColor: Theme.of(context).backgroundColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Theme(
          data: ThemeData(
              colorScheme:
                  ColorScheme.light(primary: Theme.of(context).primaryColor)),
          child: Stepper(
              onStepTapped: _tapped,
              currentStep: _currentStep,
              steps: [
                Step(
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                    title: const Text("Dados pessoais"),
                    content: Form(
                        key: _personalDataFormKey,
                        child: Column(
                          children: [
                            _formFieldFactory(
                              label: "Nome do auxiliado",
                              isMandatory: true,
                              controller: _requesterController,
                            ),
                            _formFieldFactory(
                              label: "Endereço",
                              isMandatory: true,
                              controller: _addressController,
                            ),
                            _formFieldFactory(
                              label: "Cidade",
                              isMandatory: true,
                              controller: _cityController,
                            ),
                            _formFieldFactory(
                              label: "Pix",
                              isMandatory: false,
                              controller: _pixController,
                            )
                          ],
                        ))),
                Step(
                    isActive: _currentStep >= 1,
                    state: _currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled,
                    title: const Text("Descrição do auxilio"),
                    content: Form(
                      key: _requestDataFormkey,
                      child: Column(
                        children: [
                          TextFormField(
                            onChanged: _validateRequestForm,
                            maxLines: 10,
                            controller: _descriptionController,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                                labelText: "Descrição completa",
                                border: OutlineInputBorder()),
                            validator: (description) {
                              if (description!.trim().isEmpty) {
                                return "Campo obrigatório";
                              }
                            },
                          ),
                        ],
                      ),
                    ))
              ],
              onStepContinue: () => _continued(),
              onStepCancel: () => _cancelled()),
        ),
      ),
    );
  }

  TextFormField _formFieldFactory(
      {required controller, required label, required bool isMandatory}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (field) {
        if (isMandatory && field!.trim().isEmpty) {
          return "Campo obrigatório";
        }
      },
    );
  }

  void _tapped(int step) {
    setState(() => _currentStep = step);
  }

  void _validateRequestForm(String? value) {
    if (_requestDataFormkey.currentState!.validate()) {
      setState(() {
        _isRequestFormValid = true;
      });
    } else {
      setState(() {
        _isRequestFormValid = false;
      });
    }
  }

  void _continued() {
    if (_currentStep <= 0 && _personalDataFormKey.currentState!.validate()) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      _validateRequestForm("value");
    }
  }

  void _cancelled() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  void _checkButtonPress() {
    if (_editedRequest.id == null) {
      _editedRequest.creator = widget.model.firebaseUser!.uid;
    }

    _editedRequest.pix = _pixController.text;
    _editedRequest.city = _cityController.text;
    _editedRequest.status = Constants.idStatusOpen;
    _editedRequest.address = _addressController.text;
    _editedRequest.requester = _requesterController.text;
    _editedRequest.description = _descriptionController.text;

    RequestReposiroty()
        .saveRequest(requestData: RequestData().toMap(_editedRequest))
        .then((value) => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const RequestPage())));
  }
}
