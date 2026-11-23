import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formateadaFecha(String fecha) {
  DateTime fechaDateTime = DateTime.parse(fecha);
  return DateFormat('dd/MM/yyyy').format(fechaDateTime);
}

String formateadaHora(String hora) {
  DateTime horaDateTime = DateTime.parse(hora);
  return DateFormat('HH:mm').format(horaDateTime);
}

String formateadaFechaApi(Timestamp fechaHora) {
  return DateFormat('dd/MM/yyyy').format(fechaHora.toDate());
}

String formateadaHoraApi(Timestamp fechaHora) {
  return DateFormat('HH:mm').format(fechaHora.toDate());
}

String formatearFechaApi(DateTime fecha) {
  return DateFormat('yyyy-MM-dd HH:mm').format(fecha);
}
