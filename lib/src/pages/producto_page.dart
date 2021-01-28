import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidators/src/bloc/provider.dart';

import 'package:formvalidators/src/models/producto_model.dart';
import 'package:formvalidators/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';


class ProductoPage extends StatefulWidget {

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {

  final formKey           = GlobalKey<FormState>();
  final scaffoldKey       = GlobalKey<ScaffoldState>();

  ProductosBloc productosBloc;
  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  File file;

  @override
  Widget build(BuildContext context) {

    productosBloc = Provider.productosBloc(context);

    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;

    if( prodData != null ) {
      producto = prodData;
    }


    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual), 
            onPressed: () => _seleccionarFoto( ImageSource.gallery )
          ),
          IconButton(
            icon: Icon(Icons.camera_alt), 
            onPressed: () => _seleccionarFoto( ImageSource.camera )
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(),
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget _crearNombre () {

    return TextFormField(
      initialValue: producto.nombre,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: ( value ) => producto.nombre = value,
      validator: ( value ) {
        if( value.length < 3){
          return 'Ingrese el numero del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio () {

    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      onSaved: ( value ) => producto.valor = double.parse( value ),
      validator: ( value ) {

        if ( utils.isNumeric(value) ) {
          return null;
        } else {
          return 'Solo numeros';
        }

      },
    );
  }

  Widget _crearDisponible() {

    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: ( value ) => setState((){
        producto.disponible = value;
      }),
    );
  }

  Widget _crearBoton() {

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      icon: Icon(Icons.save), 
      label: Text('Guardar'),
      onPressed: ( _guardando ) ? null : _submit, 
    );
    
  }


  void _submit() async {

    if( !formKey.currentState.validate() ) return;

    //Codigo cuando el formulario cumple las validaciones

    formKey.currentState.save();

    setState(() {_guardando = true;});

    if( file != null) {
      producto.fotoUrl = await productosBloc.subirFoto(file);
    }

    if ( producto.id == null) {
      productosBloc.agregarProducto( producto );
    } else {
      productosBloc.editarProducto( producto );
    }

    //setState(() {_guardando = false;});
    _crearSnackbar( 'Registro guardado' );

    Navigator.pop(context);


  }

  void _crearSnackbar( String mensaje) {

    final snackbar = SnackBar(
      content: Text( mensaje ),
      duration: Duration( milliseconds: 1500 ),
    );

    scaffoldKey.currentState.showSnackBar( snackbar );
  }

  Widget _mostrarFoto() {

    if( producto.fotoUrl != null ){
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'), 
        image: NetworkImage( producto.fotoUrl ),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }

    return Image(
      image: AssetImage( file?.path ?? 'assets/no-image.png'),
      height: 300.0,
      fit: BoxFit.cover,
    );
  }

  _seleccionarFoto( ImageSource origen) async {

    file = await ImagePicker.pickImage(
      source: origen
    );

    if(file != null) {
      producto.fotoUrl = null;
    }

    setState(() {});
  }

}