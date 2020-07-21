import 'package:LikeApp/Report/reciepReport.dart';
import 'package:flutter/material.dart';
import '../Models/reportData.dart';

List<GlobalKey<FormState>> formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];

class StepperBody extends StatefulWidget {
  StepperBody({Key key}) : super(key: key);
  @override
  _StepperBodyState createState() => _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {
  int currStep = 0;
  static var _focusNode = FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static ReportData data = ReportData();
  // static DateTime selectedDate = DateTime.now();

  List<Step> steps = [
    Step(
        title: const Text('Nombre'),
        //subtitle: const Text('Enter your name'),
        isActive: true,
        //state: StepState.error,
        state: StepState.indexed,
        content: Form(
          key: formKeys[0],
          child: Column(
            children: <Widget>[
              TextFormField(
                focusNode: _focusNode,
                keyboardType: TextInputType.text,
                autocorrect: false,
                onSaved: (String value) {
                  data.name = value;
                },
                maxLines: 1,
                //initialValue: 'Aseem Wangoo',
                validator: (String value) {
                  if (value.isEmpty || value.length < 1) {
                    return 'Introduce el nombre';
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Nombre del productor',
                    hintText: 'Nombre completo',
                    //filled: true,
                    icon: const Icon(Icons.person),
                    labelStyle:
                        TextStyle(decorationStyle: TextDecorationStyle.solid)),
              ),
            ],
          ),
        )),
    Step(
        title: const Text('Lugar'),
        //subtitle: const Text('Enter your name'),
        isActive: true,
        //state: StepState.error,
        state: StepState.indexed,
        content: Form(
          key: formKeys[1],
          child: Column(
            children: <Widget>[
              TextFormField(
                focusNode: _focusNode,
                keyboardType: TextInputType.text,
                autocorrect: false,
                onSaved: (String value) {
                  data.name = value;
                },
                maxLines: 1,
                //initialValue: 'Aseem Wangoo',
                validator: (String value) {
                  if (value.isEmpty || value.length < 1) {
                    return 'Introduce el lugar';
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Lugar',
                    hintText: 'Lugar',
                    //filled: true,
                    icon: const Icon(Icons.person),
                    labelStyle:
                        TextStyle(decorationStyle: TextDecorationStyle.solid)),
              ),
            ],
          ),
        )),
    Step(
        title: const Text('Nombre del predio'),
        //subtitle: const Text('Enter your name'),
        isActive: true,
        //state: StepState.error,
        state: StepState.indexed,
        content: Form(
          key: formKeys[2],
          child: Column(
            children: <Widget>[
              TextFormField(
                focusNode: _focusNode,
                keyboardType: TextInputType.text,
                autocorrect: false,
                onSaved: (String value) {
                  data.name = value;
                },
                maxLines: 1,
                //initialValue: 'Aseem Wangoo',
                validator: (String value) {
                  if (value.isEmpty || value.length < 1) {
                    return 'Introduce el nombre del predio';
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Predio',
                    hintText: 'Nombre del predio',
                    //filled: true,
                    icon: const Icon(Icons.person),
                    labelStyle:
                        TextStyle(decorationStyle: TextDecorationStyle.solid)),
              ),
            ],
          ),
        )),
    Step(
        title: const Text('Cultivo'),
        //subtitle: const Text('Enter your name'),
        isActive: true,
        //state: StepState.error,
        state: StepState.indexed,
        content: Form(
          key: formKeys[4],
          child: Column(
            children: <Widget>[
              TextFormField(
                focusNode: _focusNode,
                keyboardType: TextInputType.text,
                autocorrect: false,
                onSaved: (String value) {
                  data.name = value;
                },
                maxLines: 1,
                //initialValue: 'Aseem Wangoo',
                validator: (String value) {
                  if (value.isEmpty || value.length < 1) {
                    return 'Introduce el nombre del cultivo';
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Cultivo',
                    hintText: 'Nombre del cultivo',
                    //filled: true,
                    icon: const Icon(Icons.person),
                    labelStyle:
                        TextStyle(decorationStyle: TextDecorationStyle.solid)),
              ),
            ],
          ),
        )),
    Step(
        title: const Text('Observaciones'),
        //subtitle: const Text('Enter your name'),
        isActive: true,
        //state: StepState.error,
        state: StepState.indexed,
        content: Form(
          key: formKeys[5],
          child: Column(
            children: <Widget>[
              TextFormField(
                focusNode: _focusNode,
                keyboardType: TextInputType.text,
                autocorrect: false,
                onSaved: (String value) {
                  data.name = value;
                },
                maxLines: 2,
                //initialValue: 'Aseem Wangoo',
                validator: (String value) {
                  if (value.isEmpty || value.length < 1) {
                    return 'Introduce observaciones';
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Observaciones',
                    hintText: '',
                    //filled: true,
                    icon: const Icon(Icons.person),
                    labelStyle:
                        TextStyle(decorationStyle: TextDecorationStyle.solid)),
              ),
            ],
          ),
        )),
    Step(
        title: const Text('Phone'),
        //subtitle: const Text('Subtitle'),
        isActive: true,
        //state: StepState.editing,
        state: StepState.indexed,
        content: Form(
          key: formKeys[6],
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.phone,
                autocorrect: false,
                validator: (String value) {
                  if (value.isEmpty || value.length < 10) {
                    return 'Please enter valid number';
                  }
                },
                onSaved: (String value) {
                  data.phone = value;
                },
                maxLines: 1,
                decoration: InputDecoration(
                    labelText: 'Enter your number',
                    hintText: 'Enter a number',
                    icon: const Icon(Icons.phone),
                    labelStyle:
                        TextStyle(decorationStyle: TextDecorationStyle.solid)),
              ),
            ],
          ),
        )),
    Step(
        title: const Text('Email'),
        // subtitle: const Text('Subtitle'),
        isActive: true,
        state: StepState.indexed,
        // state: StepState.disabled,
        content: Form(
          key: formKeys[7],
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: (String value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Please enter valid email';
                  }
                },
                onSaved: (String value) {
                  data.email = value;
                },
                maxLines: 1,
                decoration: InputDecoration(
                    labelText: 'Enter your email',
                    hintText: 'Enter a email address',
                    icon: const Icon(Icons.email),
                    labelStyle:
                        TextStyle(decorationStyle: TextDecorationStyle.solid)),
              ),
            ],
          ),
        )),
    Step(
        title: const Text('Age'),
        // subtitle: const Text('Subtitle'),
        isActive: true,
        state: StepState.indexed,
        content: Form(
          key: formKeys[8],
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.number,
                autocorrect: false,
                validator: (String value) {
                  if (value.isEmpty || value.length > 2) {
                    return 'Please enter valid age';
                  }
                },
                maxLines: 1,
                onChanged: (String value) {
                  data.age = value;
                },
                decoration: InputDecoration(
                    labelText: 'Enter your age',
                    hintText: 'Enter age',
                    icon: const Icon(Icons.explicit),
                    labelStyle:
                        TextStyle(decorationStyle: TextDecorationStyle.solid)),
              ),
            ],
          ),
        )),
  ];

  @override
  Widget build(BuildContext context) {
    void showSnackBarMessage(String message,
        [MaterialColor color = Colors.red]) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
    }

    void _submitDetails() {
      final FormState formState = _formKey.currentState;

      if (!formState.validate()) {
        // showSnackBarMessage('Please enter correct data');
        Navigator.of(context).pop();
      } else {
        formState.save();
        print("Name: ${data.name}");
        print("Phone: ${data.phone}");
        print("Email: ${data.email}");
        print("Age: ${data.age}");

        showDialog(
            context: context,
            child: AlertDialog(
              title: Text("Details"),
              //content:  Text("Hello World"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("Name : " + data.name),
                    Text("Phone : " + data.phone),
                    Text("Email : " + data.email),
                    Text("Age : " + data.age),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
      }
    }

    return Container(
        child: Form(
      key: _formKey,
      child: ListView(shrinkWrap: true, children: <Widget>[
        Stepper(
          physics: ClampingScrollPhysics(),
          //  controlsBuilder: (BuildContext context,
          // {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
          // return Row(
          //   children: <Widget>[
          //     FlatButton(
          //       onPressed: onStepContinue,
          //       child: const Text('Siguiente'),
          //     ),
          //     FlatButton(
          //       onPressed: onStepCancel,
          //       child: const Text('Regresar'),
          //     ),
          //   ],
          // );
          // },
          steps: steps,
          type: StepperType.vertical,
          currentStep: this.currStep,
          onStepContinue: () {
            setState(() {
              if (formKeys[currStep].currentState.validate()) {
                if (currStep < steps.length - 1) {
                  currStep = currStep + 1;
                } else {
                  currStep = 0;
                }
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Llena correctamente el paso $currStep')));

                if (currStep == 1) {
                  print('First Step');
                  print('object' + FocusScope.of(context).toStringDeep());
                }
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (currStep > 0) {
                currStep = currStep - 1;
              } else {
                currStep = 0;
              }
            });
          },
          onStepTapped: (step) {
            setState(() {
              currStep = step;
            });
          },
        ),
        RaisedButton(
          child: Text(
            'Agregar Receta',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return ReciepReport(data);
            // }));

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReciepReport(data)),
            );
          },
          color: Colors.green,
        )
      ]),
    ));
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
      print('Has focus: $_focusNode.hasFocus');
    });
  }

  // @override
  // void dispose() {
  // _focusNode.dispose();
  //   super.dispose();
  // }
}
