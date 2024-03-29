import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();

  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _formData = Map<String, Object>();

  bool isLoanding = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  void updateImage() => setState(() {});

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endsWithFile;
  }

  Future<void> _submitForm() async {
    setState(() {
      isLoanding = true;
    });
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();

    try {
      await Provider.of<ProductList>(context, listen: false)
          .saveProdut(_formData);
          
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Ocorreu um erro!"),
          content: const Text(
            "Ocorreu um erro ao salvar o produto",
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'))
          ],
        ),
      );
    } finally {
      setState(() {
        isLoanding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Produto'),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: isLoanding
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['name']?.toString(),
                      decoration: const InputDecoration(
                        labelText: "Nome",
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                      onSaved: (name) => _formData['name'] = name ?? '',
                      validator: (_name) {
                        final name = _name ?? '';
                        if (name.trim().isEmpty) {
                          return 'O campo nome não pode ficar em branco';
                        }
                        if (name.trim().length < 3) {
                          return 'O campo nome precisa de no minimo 3 letras';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price']?.toString(),
                      decoration: const InputDecoration(
                        labelText: "Preço",
                      ),
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocus,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onFieldSubmitted: (value) => FocusScope.of(context)
                          .requestFocus(_descriptionFocus),
                      onSaved: (price) =>
                          _formData['price'] = double.parse(price ?? '0'),
                      validator: (value) {
                        final priceString = value ?? '-1';
                        final price = double.tryParse(priceString) ?? -1;

                        if (price <= 0) {
                          return 'Informe um preço válido';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description']?.toString(),
                      decoration: const InputDecoration(
                        labelText: "Descrição",
                      ),
                      focusNode: _descriptionFocus,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSaved: (description) =>
                          _formData['description'] = description ?? '',
                      validator: (_description) {
                        final description = _description ?? '';
                        if (description.trim().isEmpty) {
                          return 'O campo Descrição não pode ficar em branco';
                        }
                        if (description.trim().length < 10) {
                          return 'O campo Descrição precisa de no minimo 3 letras';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "URL da Imagem",
                            ),
                            focusNode: _imageUrlFocus,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            onFieldSubmitted: (_) => _submitForm(),
                            onSaved: (imageUrl) =>
                                _formData['imageUrl'] = imageUrl ?? '',
                            validator: (value) {
                              final imageUrl = value ?? '';
                              if (!isValidImageUrl(imageUrl)) {
                                return 'Informe uma URL valida.';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(top: 10, left: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Informe a URL')
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
