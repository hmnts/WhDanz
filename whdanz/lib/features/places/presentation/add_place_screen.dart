import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = 'discoteca';

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addPlace),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del lugar',
                  prefixIcon: Icon(Icons.place),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el nombre del lugar';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.md),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa la dirección';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.md),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Tipo de lugar',
                  prefixIcon: Icon(Icons.category),
                ),
                items: const [
                  DropdownMenuItem(value: 'discoteca', child: Text('Discoteca')),
                  DropdownMenuItem(value: 'academia', child: Text('Academia')),
                  DropdownMenuItem(value: 'evento', child: Text('Evento')),
                  DropdownMenuItem(value: 'espacio_publico', child: Text('Espacio público')),
                ],
                onChanged: (value) {
                  setState(() => _selectedType = value!);
                },
              ),
              const SizedBox(height: AppDimensions.md),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: AppDimensions.lg),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(
                    color: AppColors.textMuted,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 48,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      'Añadir foto',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.lg),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lugar añadido correctamente')),
                    );
                    context.pop();
                  }
                },
                child: const Text('Guardar lugar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
