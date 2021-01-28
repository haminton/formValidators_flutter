// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);

import 'dart:convert';

ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str));

String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
    String id;
    String nombre;
    double valor;
    bool disponible;
    String fotoUrl;

    ProductoModel({
        this.id,
        this.nombre = '',
        this.valor = 0.0,
        this.disponible = true,
        this.fotoUrl,
    });

    factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        id          : json["id"],
        nombre      : json["nombre"],
        valor       : json["valor"],
        disponible  : json["disponible"],
        fotoUrl     : json["fotoUrl"],
    );

    Map<String, dynamic> toJson() => {
        //"id"          : id,
        "nombre"      : nombre,
        "valor"       : valor,
        "disponible"  : disponible,
        "fotoUrl"     : fotoUrl,
    };
}
