import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
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
  var _isInit = true;
  var _isLoading = false;
  var _initValues = {
    'title':'',
    'description':'',
    'price':'',
    'imageUrl':'',
  };
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
      id:'' , title: '', description: '', price: 0, imageUrl: ''
  );
  @override
  void initState(){

    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
  @override
  void didChangeDependencies(){
    if(_isInit){
      if(ModalRoute.of(context)?.settings.arguments != null) {
        final productId = ModalRoute
            .of(context)
            ?.settings
            .arguments as String;
        if (productId != null) {
          _editedProduct =
              Provider.of<Products>(context, listen: false).findById(productId);
          _initValues = {
            'title': _editedProduct.title,
            'description': _editedProduct.description,
            'price': _editedProduct.price.toString(),
            'imageUrl': ''
          };
          _imageUrlController.text = _editedProduct.imageUrl;
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
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
  Future<void> _saveForm() async{
    final isValid = _form.currentState!.validate();
    if(!isValid){
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if(_editedProduct.id != ''){
      Provider.of<Products>(context,listen: false).updateProducts(_editedProduct.id,_editedProduct);
      setState(() {
        _isLoading = false;
      });
    }
    else{
      try{
        await Provider.of<Products>(context,listen: false).addProduct(_editedProduct);
      }
      catch(error){
         showDialog(
            context: context,
            builder: (ctx) =>
                AlertDialog(
                  title: Text('An error occurred!'),
                  content: Text('Something went wrong'),
                  actions: [
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text('Okay')
                    )
                  ],
                )
        );
      }
      finally{
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }

    }
    //



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
      body:_isLoading ? Center(
        child: CircularProgressIndicator(),
      ) :  Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key:_form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please provide a title';
                  }
                  else{
                    return null;
                  }
                },
                onSaved: (value){
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: value!,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please enter a price';
                  }
                  if(double.tryParse(value) == null){
                    return 'Please enter a valid number.';
                  }
                  if(double.parse(value) <= 0){
                    return 'Please enter a number greate than zero.';
                  }
                  return null;
                },
                onSaved: (value){
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(value!),
                      imageUrl: _editedProduct.imageUrl,
                      isFavorite: _editedProduct.isFavorite
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                focusNode: _descriptionFocusNode,
                textInputAction: TextInputAction.next,
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please provide a description';
                  }
                  if(value.length < 10){
                    return 'Description should be more than 10 characters';
                  }
                  return null;
                },
                onSaved: (value){
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: value!,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      isFavorite: _editedProduct.isFavorite

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
                        //initialValue: _initValues['imageUrl'],
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) => _saveForm(),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please enter an image URL';
                          }
                          if(!value.startsWith('http') || !value.startsWith('https')){
                            return 'Please enter a valid URL';
                          }
                          if(!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')){
                            return 'Please enter a valid URL';
                          }
                          return null;
                        },
                        onSaved: (value){
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              isFavorite: _editedProduct.isFavorite,
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