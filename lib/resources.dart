class Strings {
  static const errorUrl = 'Код не ведет на gosuslugi.ru';
  static const verifyUrl = 'https://www.gosuslugi.ru/covid-cert/verify/';
  static const mainTitle = 'Vaccination QRCode';
  static const readQR = 'Наведите на QR-код';
  static const loading = 'загрузка...';
  static const noPermission = 'нет разрешения';
  static const ok = 'ОК';
  static const yandex = 'yandex.ru';
  static const noInternet = "Нет доступа в интернет";
  static const noConnect = "Включите интернет";
  static const info = "Информация";
}

String flashStatus(bool flash) {
  return flash == true ? "вкл" : "выкл";
}

