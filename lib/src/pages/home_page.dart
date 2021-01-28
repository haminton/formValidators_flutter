import 'package:flutter/material.dart';

import 'package:formvalidators/src/bloc/provider.dart';
import 'package:formvalidators/src/models/producto_model.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productosBloc = Provider.productosBloc(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home page')
      ),
      body: _crearListado( productosBloc ),
      floatingActionButton: _crearBoton( context ),
    );
  }

  Widget _crearListado( ProductosBloc productosBloc) {

    return StreamBuilder(
      stream: productosBloc.productosStream ,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
        //print(snapshot.hasData);
        if ( snapshot.hasData ) {

          final productos = snapshot.data;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: ( context, i )  => _crearItem( context, productosBloc, productos[i] ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

    // return FutureBuilder(
    //   future: productosProvider.cargarProductos(),
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
        
    //     if ( snapshot.hasData ) {

    //       final productos = snapshot.data;
    //       return ListView.builder(
    //         itemCount: productos.length,
    //         itemBuilder: ( context, i )  => _crearItem( context, productos[i] ),
    //       );
    //     } else {
    //       return Center(child: CircularProgressIndicator());
    //     }
    //   },
    // );
  }

  Widget _crearItem(BuildContext context, ProductosBloc productosBloc, ProductoModel producto) {

    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      onDismissed: ( dissmised ) => productosBloc.borrarProducto(producto.id),
      child: Card(
        child: Column(
          children: <Widget>[

            ( producto.fotoUrl == null ) 
            ? Image(image: AssetImage('assets/no-image.png'))
            : FadeInImage(
              placeholder: AssetImage('assets/jar-loading.gif'), 
              image: NetworkImage( producto.fotoUrl ),
              height: 300.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            ListTile(
              title: Text( producto.nombre ),
              subtitle: Text( producto.valor.toString() ),
              onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto),
            ),
          ],
        ),
      )
    );

  }

  Widget _crearBoton( BuildContext context) {

    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, 'producto'),
      backgroundColor: Colors.deepPurple
    );
  }
  
}