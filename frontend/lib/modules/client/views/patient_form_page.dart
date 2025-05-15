import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/modules/client/controllers/patient_controller.dart';

class PatientFormPage extends StatelessWidget {
  final PatientController controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController medicalConditionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  PatientFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Paciente')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'Idade'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: weightController,
                  decoration: const InputDecoration(labelText: 'Peso (kg)'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: heightController,
                  decoration: const InputDecoration(labelText: 'Altura (cm)'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: medicalConditionController,
                  decoration: const InputDecoration(labelText: 'Condição Médica'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Telefone'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      controller.createPatient(
                        name: nameController.text,
                        age: int.parse(ageController.text),
                        weight: double.parse(weightController.text),
                        height: double.parse(heightController.text),
                        medicalCondition: medicalConditionController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                      );
                      Get.back(); // volta à tela anterior após salvar
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
