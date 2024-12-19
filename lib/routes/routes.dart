// routes.dart

class TRoutes {
  static const login = '/login';
  static const forgetPassword = '/forgetPassword';
  static const resetPassword = '/resetPassword';
  static const dashboard = '/dashboard';
  static const media = '/media';

  static const banners = '/banners';
  static const createBanner = '/crearBanner';
  static const editBanner = '/editarBanner';

  static const products = '/productos';
  static const createProduct = '/crearProducto';
  static const editProduct = '/editarProducto';

  static const categories = '/categorias';
  static const createCategory = '/crearCategoria';
  static const editCategory = '/editarCategoria';

  static const brands = '/marcas';
  static const createBrand = '/crearMarca';
  static const editBrand = '/editarMarca';

  static const customers = '/clientes';
  static const createCustomer = '/crearCliente';
  static const customerDetails = '/clieteDetalle';

  static const orders = '/pedidos';
  static const orderDetails = '/pedidoDetalles';

  static const coupons = '/cupons';
  static const createCoupon = '/crearCupones';
  static const editCoupon = '/editarCupones';

  static const settings = '/configuraciones';
  static const profile = '/perfil';

  static List sideMenuItems = [
    login,
    forgetPassword,
    dashboard,
    media,
    products,
    categories,
    brands,
    customers,
    orders,
    coupons,
    settings,
    profile,
  ];
}

// All App Screens
class AppScreens {
  static const home = '/';
  static const store = '/home';
  static const favourites = '/favoritos';
  static const settings = '/configuraciones';
  static const subCategories = '/sub-categorias';
  static const search = '/buscar';
  static const productReviews = '/producto-reseñas';
  static const productDetail = '/producto-detalle';
  static const order = '/orden';
  static const checkout = '/pago';
  static const cart = '/carrito';
  static const brand = '/marca';
  static const allProducts = '/todos-productos';
  static const userProfile = '/usuario-perfil';
  static const userAddress = '/usuario-direcciones';
  static const signUp = '/crear-cuenta';
  static const signupSuccess = '/crearcuenta-success';
  static const verifyEmail = '/verificar-correo';
  static const signIn = '/iniciar-sesion';
  static const resetPassword = '/resetear-contraseña';
  static const forgetPassword = '/olvide-contraseña';
  static const onBoarding = '/pantalla-inicio';

  static List<String> allAppScreenItems = [
    onBoarding,
    signIn,
    signUp,
    verifyEmail,
    resetPassword,
    forgetPassword,
    home,
    store,
    favourites,
    settings,
    subCategories,
    search,
    productDetail,
    productReviews,
    order,
    checkout,
    cart,
    brand,
    allProducts,
    userProfile,
    userAddress,
  ];
}
