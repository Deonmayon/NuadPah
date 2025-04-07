import 'package:shared_preferences/shared_preferences.dart';

/// A singleton class to manage favorite massage data globally
class FavoriteManager {
  // Singleton instance
  static final FavoriteManager instance = FavoriteManager._internal();

  // Private constructor for singleton
  FavoriteManager._internal();

  // Cache of single favorite massages
  Set<int> _singleFavorites = {};
  
  // Cache of set favorite massages
  Set<int> _setFavorites = {};

  // Flag to track if data has been loaded
  bool _isInitialized = false;

  // Method to initialize favorites from SharedPreferences
  Future<void> init() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();
    
    // Load single favorites
    final singleFavs = prefs.getStringList('cachedFavorites') ?? [];
    _singleFavorites = singleFavs.map((id) => int.parse(id)).toSet();
    
    // Load set favorites
    final setFavs = prefs.getStringList('cachedSetFavorites') ?? [];
    _setFavorites = setFavs.map((id) => int.parse(id)).toSet();
    
    _isInitialized = true;
  }

  // Check if a single massage is in favorites
  bool? isSingleFavorite(int massageId) {
    if (!_isInitialized) return null;
    return _singleFavorites.contains(massageId);
  }
  
  // Check if a set massage is in favorites
  bool? isSetFavorite(int massageId) {
    if (!_isInitialized) return null;
    return _setFavorites.contains(massageId);
  }

  // Update a single massage favorite status
  void updateSingleFavorite(int massageId, bool isFavorite) {
    if (isFavorite) {
      _singleFavorites.add(massageId);
    } else {
      _singleFavorites.remove(massageId);
    }
    _saveSingleFavorites();
  }
  
  // Update a set massage favorite status
  void updateSetFavorite(int massageId, bool isFavorite) {
    if (isFavorite) {
      _setFavorites.add(massageId);
    } else {
      _setFavorites.remove(massageId);
    }
    _saveSetFavorites();
  }
  
  // Set all single favorites at once
  void setSingleFavorites(List<int> favorites) {
    _singleFavorites = favorites.toSet();
    _saveSingleFavorites();
  }
  
  // Set all set favorites at once
  void setSetFavorites(List<int> favorites) {
    _setFavorites = favorites.toSet();
    _saveSetFavorites();
  }
  
  // Save single favorites to SharedPreferences
  Future<void> _saveSingleFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('cachedFavorites', 
        _singleFavorites.map((id) => id.toString()).toList());
  }
  
  // Save set favorites to SharedPreferences
  Future<void> _saveSetFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('cachedSetFavorites', 
        _setFavorites.map((id) => id.toString()).toList());
  }
}
