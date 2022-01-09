import 'dart:convert';

import 'package:flutter/services.dart';

import 'entities.dart';
export 'entities.dart';

const methods = Methods._();

class Methods {
  const Methods._();

  static const _channel = MethodChannel("methods");

  Future<String> _invoke(String method, dynamic params) async {
    String resp = await _channel.invokeMethod(
        "invoke",
        jsonEncode({
          "method": method,
          "params": params is String ? params : jsonEncode(params),
        }));
    var response = _Response.fromJson(jsonDecode(resp));
    if (response.errorMessage.isNotEmpty) {
      throw StateError(response.errorMessage);
    }
    return response.responseData;
  }

  Future init() {
    return _invoke("init", "");
  }

  Future<String> loadProperty(String propertyKey) {
    return _invoke("load_property", propertyKey);
  }

  Future<ComicsResponse> comics(String slug, SortBy sortBy, int page) async {
    final rsp = await _invoke("comics", {
      "categories_slug": slug,
      "sort_by": sortBy.value,
      "page": page,
    });
    return ComicsResponse.fromJson(jsonDecode(rsp));
  }

  Future<ComicsResponse> comicSearch(
      String searchQuery, SortBy sortBy, int page) async {
    final rsp = await _invoke("comic_search", {
      "search_query": searchQuery,
      "sort_by": sortBy.value,
      "page": page,
    });
    return ComicsResponse.fromJson(jsonDecode(rsp));
  }

  Future<CategoriesResponse> categories() async {
    return CategoriesResponse.fromJson(
        jsonDecode(await _invoke("categories", "")));
  }

  Future saveImageFileToGallery(String path) {
    return _channel.invokeMethod("saveImageFileToGallery", path);
  }

  Future saveProperty(String key, String v) {
    return _invoke("save_property", {"k": key, "v": v});
  }

  Future<AlbumResponse> album(int id) async {
    return AlbumResponse.fromJson(jsonDecode(await _invoke("album", id)));
  }

  Future<ChapterResponse> chapter(int id) async {
    return ChapterResponse.fromJson(jsonDecode(await _invoke("chapter", id)));
  }

  Future<CommentPage> forum(String mode, int aid, int page) async {
    return CommentPage.fromJson(jsonDecode(await _invoke("forum", {
      "mode": mode,
      "aid": aid,
      "page": page,
    })));
  }

  Future<FavoritesResponse> favorites(int page) async {
    return FavoritesResponse.fromJson(
      jsonDecode(await _invoke("favorites", page)),
    );
  }

  Future<ActionResponse> setFavorite(int aid) async {
    return ActionResponse.fromJson(
      jsonDecode(await _invoke("set_favorite", aid)),
    );
  }

  Future updateViewLog(int id, int lastViewChapterId, int lastViewPage) {
    return _invoke("update_view_log", {
      "id": id,
      "last_view_chapter_id": lastViewChapterId,
      "last_view_page": lastViewPage,
    });
  }

  Future<ViewLog?> findViewLog(int id) async {
    final map = jsonDecode(await _invoke("find_view_log", id));
    if (map == null) {
      return null;
    }
    return ViewLog.fromJson(map);
  }

  Future cleanAllCache() async {
    return _invoke("clean_all_cache", "params");
  }

  Future<String> jm3x4Cover(int comicId) {
    return _invoke("jm_3x4_cover", comicId);
  }

  Future<String> jmPageImage(int id, String imageName) {
    return _invoke("jm_page_image", {"id": id, "image_name": imageName});
  }

  Future<String> jmPhotoImage(String imageName) {
    return _invoke("jm_photo_image", imageName);
  }

  Future<ImageSize> imageSize(String path) async {
    return ImageSize.fromJson(jsonDecode(await _invoke("image_size", path)));
  }

  Future httpGet(String versionUrl) {
    return _invoke("http_get", versionUrl);
  }

  Future<String> loadApiHost() {
    return _invoke("load_api_host", "");
  }

  Future<String> loadCdnHost() {
    return _invoke("load_cdn_host", "");
  }

  Future saveApiHost(String choose) {
    return _invoke("save_api_host", choose);
  }

  Future saveCdnHost(String choose) {
    return _invoke("save_cdn_host", choose);
  }

  Future<PreLoginResponse> preLogin() async {
    return PreLoginResponse.fromJson(
      jsonDecode(await _invoke("pre_login", "")),
    );
  }

  Future<SelfInfo> login(String username, String password) async {
    return SelfInfo.fromJson(
      jsonDecode(await _invoke("login", {
        "username": username,
        "password": password,
      })),
    );
  }

  Future<CommentResponse> commentResponse(int aid, String comment) async {
    return CommentResponse.fromJson(jsonDecode(await _invoke("comment", {
      "aid": aid,
      "comment": comment,
    })));
  }

  Future<CommentResponse> comment(int aid, String comment) async {
    return CommentResponse.fromJson(jsonDecode(await _invoke("comment", {
      "aid": aid,
      "comment": comment,
    })));
  }

  Future<CommentResponse> childComment(
    int aid,
    String comment,
    int? commentId,
  ) async {
    return CommentResponse.fromJson(jsonDecode(await _invoke("child_comment", {
      "aid": aid,
      "comment": comment,
      "comment_id": commentId,
    })));
  }

  Future<String> loadUsername() {
    return _invoke("load_username", "");
  }

  Future<String> loadPassword() {
    return _invoke("load_password", "");
  }
}

class _Response {
  late String errorMessage;
  late String responseData;

  _Response.fromJson(Map json) {
    errorMessage = json["error_message"];
    responseData = json["response_data"];
  }
}
