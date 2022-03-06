import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../providers/product.dart';
class EditProductScreen extends StatefulWidget{
  static const routeName = '/edit-product';
  @override
  State<StatefulWidget> createState() {
    return _EditProductScreenState();
  }
}

class _EditProductScreenState extends State<EditProductScreen>{
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
      id:'' , title: '', description: '', price: 0, imageUrl: ''
  );
  @override
  void initState(){
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }
  @override
  void dispose(){
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }
  void _updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus){
      setState(() {
      });
    }
  }
  void _saveForm(){
    _form.currentState!.save();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key:_form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value){
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: value!,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value){
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(value!),
                      imageUrl: _editedProduct.imageUrl
                  );
                },
              ),
              TextFormField(
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                focusNode: _descriptionFocusNode,
                textInputAction: TextInputAction.next,
                onSaved: (value){
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: value!,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl
                  );
                },

              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top:8,right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color:Colors.grey,width: 1)
                      ),
                      child: _imageUrlController.text.isEmpty ? Text('Enter a URL') :
                           FittedBox(
                             child: Image.network(_imageUrlController.text,fit: BoxFit.cover,),
                           ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) => _saveForm(),
                        onSaved: (value){
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: value!
                          );
                        },
                      ),
                    )


                ],
              )
            ],
          ),
        ),
      ) ,
    );
  }
}