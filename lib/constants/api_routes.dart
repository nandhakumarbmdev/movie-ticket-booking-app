class ApiRoutes {
  // Users
  static const createUser = '/user/create_user';
  static const updateUser = '/user/update_profile';
  static const getUserByEmail = '/user/get_user_by_email';
  // Movies
  static const getAllMovies = '/user/get_all_movies';
  // Theatres
  static const getTheatresByMovie = '/user/get_theatres_by_movie';
  static const getAllTheatres ="/user/get_all_theatres";
  static const getMoviesByTheatre = '/user/get_movies_by_theatre';
  // Shows
  static const getShowSeats = '/user/shows/seats';
  static const getShowDetails = '/user/shows_details';
  // Reviews
  static const getReviewsByMovie = '/user/get_reviews_by_movie';
  static const createReview = '/user/create_review';
  // Bookings
  static const createBooking = '/user/create_booking';


  //Admin
  static const createMovie = '/admin/create_movie';
  static const updateMovie = '/admin/update_movie';
  static const deleteMovie = "/admin/delete_movie";

  // Theatre
  static const createTheatre = '/admin/create_theatre';
  static const updateTheatre = '/admin/update_theatre';
  static const deleteTheatre = "/admin/delete_theatre";
  static const getAllTheatre = "/admin/get_theatres";

  static const getScreenByTheatre = "/admin/get_screens_by_theatre";
  static const deleteScreen = "/admin/delete_screen";
  static const updateScreen = "/admin/update_screen";
  static const addScreen = "/admin/add_screen";
}
