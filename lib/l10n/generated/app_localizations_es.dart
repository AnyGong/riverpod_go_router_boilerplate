// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Flutter Boilerplate';

  @override
  String get welcomeMessage => '¡Bienvenido a la aplicación!';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get signUp => 'Registrarse';

  @override
  String get settings => 'Configuración';

  @override
  String get profile => 'Perfil';

  @override
  String get home => 'Inicio';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get biometricAuthentication => 'Autenticación biométrica';

  @override
  String get biometricPromptTitle => 'Autenticar';

  @override
  String get biometricPromptSubtitle => 'Verifica tu identidad para continuar';

  @override
  String get biometricPromptCancel => 'Cancelar';

  @override
  String get errorGeneric => 'Algo salió mal. Por favor, inténtalo de nuevo.';

  @override
  String get errorNetwork => 'Error de red. Por favor, verifica tu conexión.';

  @override
  String get errorTimeout =>
      'Tiempo de espera agotado. Por favor, inténtalo de nuevo.';

  @override
  String get errorUnauthorized =>
      'Sesión expirada. Por favor, inicia sesión de nuevo.';

  @override
  String get retry => 'Reintentar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get loading => 'Cargando...';

  @override
  String get noData => 'No hay datos disponibles';

  @override
  String get searchHint => 'Buscar...';

  @override
  String version(String version) {
    return 'Versión $version';
  }

  @override
  String itemCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementos',
      one: '1 elemento',
      zero: 'Sin elementos',
    );
    return '$_temp0';
  }

  @override
  String lastUpdated(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Última actualización: $dateString';
  }

  @override
  String get onboardingTitle1 => 'Bienvenido';

  @override
  String get onboardingDescription1 =>
      'Descubre funciones increíbles y comienza con nuestra aplicación.';

  @override
  String get onboardingTitle2 => 'Explorar';

  @override
  String get onboardingDescription2 =>
      'Navega por una amplia variedad de contenido personalizado para ti.';

  @override
  String get onboardingTitle3 => 'Comenzar';

  @override
  String get onboardingDescription3 => 'Crea tu cuenta y comienza tu viaje.';

  @override
  String get skip => 'Omitir';

  @override
  String get next => 'Siguiente';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get offlineModeEnabled => 'Modo sin conexión activado';

  @override
  String get backOnline => 'Estás de vuelta en línea';
}
