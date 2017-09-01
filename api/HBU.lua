--- OnApplicationQuit.
function HBU.OnApplicationQuit() end

--- OnDamageSent
-- @param damage of type Float
-- @param point of type Vector3
HBU.OnDamageSent = function(dmg, point)
--- GetSetting.
-- @param setting of type String
-- @return Single
function HBU.GetSetting(setting) end

--- GetPlayers.
-- @return OtherPlayer[]
function HBU.GetPlayers() end

--- TakeScreenshot.
-- @param path of type String
-- @param onFinished of type Action
-- @param superSize of type Int32
function HBU.TakeScreenshot(path, onFinished, superSize) end

--- TeleportPlayer.
-- @param pos of type Vector3
function HBU.TeleportPlayer(pos) end

--- AttachWaypoint.
-- @param obj of type GameObject
-- @param pos of type Vector3
-- @param type of type String
-- @param team of type String
-- @param text of type String
-- @param enableInBuilder of type Boolean
-- @param enableInMenu of type Boolean
-- @param enableIfSelected of type Boolean
-- @param enableIfEnemy of type Boolean
function HBU.AttachWaypoint(obj, pos, type, team, text, enableInBuilder, enableInMenu, enableIfSelected, enableIfEnemy) end

--- DestroyWaypoint.
-- @param obj of type GameObject
function HBU.DestroyWaypoint(obj) end

--- GetTeleportLocations.
-- @return TeleportLocation[]
function HBU.GetTeleportLocations() end

--- GetNearestTeleportLocation.
-- @return TeleportLocation
function HBU.GetNearestTeleportLocation() end

--- InSeat.
-- @return Boolean
function HBU.InSeat() end

--- MayControle.
-- @return Boolean
function HBU.MayControle() end

--- InBuilder.
-- @return Boolean
function HBU.InBuilder() end

--- GetKey.
-- @param name of type String
-- @return HBKeyBind
function HBU.GetKey(name) end

--- GetVehicleCountLimit.
-- @return Int32
function HBU.GetVehicleCountLimit() end

--- GetMyOldestVehicle.
-- @return GameObject
function HBU.GetMyOldestVehicle() end

--- GetSpawnError.
-- @param assetPath of type String
-- @return String
function HBU.GetSpawnError(assetPath) end

--- CanSpawnVehicle.
-- @param assetPath of type String
-- @return Boolean
function HBU.CanSpawnVehicle(assetPath) end

--- SpawnVehicle.
-- @param position of type Vector3
-- @param rotation of type Quaternion
-- @param assetPath of type String
-- @return GameObject
function HBU.SpawnVehicle(position, rotation, assetPath) end

--- SpawnVehicleAsync.
-- @param position of type Vector3
-- @param rotation of type Quaternion
-- @param assetPath of type String
-- @param onReturn of type Action`1
-- @param onError of type Action`1
-- @return Int32
function HBU.SpawnVehicleAsync(position, rotation, assetPath, onReturn, onError) end

--- StopSpawnVehicleAsync.
-- @param id of type Int32
function HBU.StopSpawnVehicleAsync(id) end

--- InitializeVehicle.
-- @param vehicle of type GameObject
function HBU.InitializeVehicle(vehicle) end

--- DropVehicle.
-- @param vehicle of type GameObject
function HBU.DropVehicle(vehicle) end

--- CleanupVehicle.
function HBU.CleanupVehicle() end

--- OpenBrowser.
-- @param path of type String
-- @param types of type String[]
-- @param tags of type String[]
-- @param onReturn of type Action`1
-- @param onCancel of type Action
-- @return GameObject
function HBU.OpenBrowser(path, types, tags, onReturn, onCancel) end

--- SaveValue.
-- @param name of type String
-- @param valueName of type String
-- @param value of type String
function HBU.SaveValue(name, valueName, value) end

--- LoadValue.
-- @param name of type String
-- @param valueName of type String
-- @return String
function HBU.LoadValue(name, valueName) end

--- FindTool.
-- @param nam of type String
-- @return GameObject
function HBU.FindTool(nam) end

--- EnableGadgetMouseScroll.
function HBU.EnableGadgetMouseScroll() end

--- DisableGadgetMouseScroll.
function HBU.DisableGadgetMouseScroll() end

--- SortByDateAscendingAsync.
-- @param paths of type String[]
-- @param OnDone of type Action`1
function HBU.SortByDateAscendingAsync(paths, OnDone) end

--- SortByDateDescendingAsync.
-- @param paths of type String[]
-- @param OnDone of type Action`1
function HBU.SortByDateDescendingAsync(paths, OnDone) end

--- SortByNameAscendingAsync.
-- @param paths of type String[]
-- @param OnDone of type Action`1
function HBU.SortByNameAscendingAsync(paths, OnDone) end

--- SortByNameDescendingAsync.
-- @param paths of type String[]
-- @param OnDone of type Action`1
function HBU.SortByNameDescendingAsync(paths, OnDone) end

--- SortByLastAccessedAscendingAsync.
-- @param paths of type String[]
-- @param OnDone of type Action`1
function HBU.SortByLastAccessedAscendingAsync(paths, OnDone) end

--- SortByLastAccessedDescendingAsync.
-- @param paths of type String[]
-- @param OnDone of type Action`1
function HBU.SortByLastAccessedDescendingAsync(paths, OnDone) end

--- SortByDateAscending.
-- @param paths of type String[]
-- @return String[]
function HBU.SortByDateAscending(paths) end

--- SortByDateDescending.
-- @param paths of type String[]
-- @return String[]
function HBU.SortByDateDescending(paths) end

--- SortByNameAscending.
-- @param paths of type String[]
-- @return String[]
function HBU.SortByNameAscending(paths) end

--- SortByNameDescending.
-- @param paths of type String[]
-- @return String[]
function HBU.SortByNameDescending(paths) end

--- SortByLastAccessedAscending.
-- @param paths of type String[]
-- @return String[]
function HBU.SortByLastAccessedAscending(paths) end

--- SortByLastAccessedDescending.
-- @param paths of type String[]
-- @return String[]
function HBU.SortByLastAccessedDescending(paths) end

function HBU.GetAssetsAsync

function HBU.GetAssetsAsync

function HBU.GetAssetsAsync

function HBU.GetAssetsAsync

function HBU.GetAssetsAsync

--- GetAssetFileAsync.
-- @param p of type String
-- @param OnDone of type Action`1
function HBU.GetAssetFileAsync(p, OnDone) end

function HBU.GetAssets

function HBU.GetAssets

function HBU.GetAssets

function HBU.GetAssets

function HBU.GetAssets

--- GetAssetImage.
-- @param p of type String
-- @return Texture2D
function HBU.GetAssetImage(p) end

--- GetAssetFile.
-- @param p of type String
-- @return String
function HBU.GetAssetFile(p) end

--- GetAssetType.
-- @param p of type String
-- @return String
function HBU.GetAssetType(p) end

--- GetAssetName.
-- @param p of type String
-- @return String
function HBU.GetAssetName(p) end

--- GetAssetInfo.
-- @param p of type String
-- @return String
function HBU.GetAssetInfo(p) end

--- GetAssetTypeInfo.
-- @param p of type String
-- @return String
function HBU.GetAssetTypeInfo(p) end

--- DeleteAsset.
-- @param p of type String
function HBU.DeleteAsset(p) end

--- CopyAsset.
-- @param p of type String
-- @param np of type String
function HBU.CopyAsset(p, np) end

--- MoveAsset.
-- @param p of type String
-- @param np of type String
function HBU.MoveAsset(p, np) end

--- RenameAsset.
-- @param p of type String
-- @param fn of type String
function HBU.RenameAsset(p, fn) end

function HBU.GetDirectories

function HBU.GetDirectories

--- CreateDirectory.
-- @param p of type String
function HBU.CreateDirectory(p) end

--- CopyDirectory.
-- @param p of type String
-- @param np of type String
function HBU.CopyDirectory(p, np) end

--- MoveDirectory.
-- @param p of type String
-- @param np of type String
function HBU.MoveDirectory(p, np) end

--- DeleteDirectory.
-- @param p of type String
-- @param np of type String
function HBU.DeleteDirectory(p, np) end

--- FileExists.
-- @param p of type String
-- @return Boolean
function HBU.FileExists(p) end

--- CopyFile.
-- @param pf of type String
-- @param pt of type String
-- @return Boolean
function HBU.CopyFile(pf, pt) end

--- MoveFile.
-- @param pf of type String
-- @param pt of type String
-- @return Boolean
function HBU.MoveFile(pf, pt) end

--- GetRandomID.
-- @return String
function HBU.GetRandomID() end

--- DeleteCacheFolder.
-- @param path of type String
-- @return Boolean
function HBU.DeleteCacheFolder(path) end

--- CreateCacheFolder.
-- @param path of type String
-- @return String
function HBU.CreateCacheFolder(path) end

--- GetExeFolder.
-- @return String
function HBU.GetExeFolder() end

--- GetLuaFolder.
-- @return String
function HBU.GetLuaFolder() end

--- GetUserDataPath.
-- @return String
function HBU.GetUserDataPath() end

--- GetFileName.
-- @param p of type String
-- @return String
function HBU.GetFileName(p) end

--- GetFileNameWithoutExtension.
-- @param p of type String
-- @return String
function HBU.GetFileNameWithoutExtension(p) end

--- GetExtension.
-- @param p of type String
-- @return String
function HBU.GetExtension(p) end

--- GetDirectoryName.
-- @param p of type String
-- @return String
function HBU.GetDirectoryName(p) end

--- XmlLoad.
-- @param path of type String
-- @return XElement
function HBU.XmlLoad(path) end

--- XmlFind.
-- @param el of type XElement
-- @param path of type String
-- @return XElement
function HBU.XmlFind(el, path) end

--- XmlElements.
-- @param el of type XElement
-- @param name of type String
-- @return XElement[]
function HBU.XmlElements(el, name) end

--- XmlValue.
-- @param el of type XElement
-- @return String
function HBU.XmlValue(el) end

--- XmlCreate.
-- @param nam of type String
-- @return XElement
function HBU.XmlCreate(nam) end

--- XmlAdd.
-- @param el of type XElement
-- @param n of type XElement
function HBU.XmlAdd(el, n) end

--- XmlSet.
-- @param el of type XElement
-- @param val of type String
function HBU.XmlSet(el, val) end

--- XmlSave.
-- @param el of type XElement
-- @param path of type String
function HBU.XmlSave(el, path) end

--- XmlClose.
-- @param el of type XElement
function HBU.XmlClose(el) end

--- GetAllInspectorComponentConfigFiles.
-- @return String[]
function HBU.GetAllInspectorComponentConfigFiles() end

--- FindInspectorComponentConfigFile.
-- @param componentName of type String
-- @return String
function HBU.FindInspectorComponentConfigFile(componentName) end

--- LoadTexture2D.
-- @param path of type String
-- @return Texture2D
function HBU.LoadTexture2D(path) end

--- SaveTexture2D.
-- @param t of type Texture2D
-- @param path of type String
-- @return Boolean
function HBU.SaveTexture2D(t, path) end

function HBU.Instantiate

function HBU.Instantiate

--- GetPrimitiveUI.
-- @param p of type String
-- @return GameObject
function HBU.GetPrimitiveUI(p) end

--- Layout.
-- @param o of type GameObject
-- @param ignore of type Boolean
-- @param minWidth of type Single
-- @param minHeight of type Single
-- @param preferredHeight of type Single
-- @param preferredWidth of type Single
-- @param flexibleHeight of type Single
-- @param flexibleWidth of type Single
-- @return LayoutElement
function HBU.Layout(o, ignore, minWidth, minHeight, preferredHeight, preferredWidth, flexibleHeight, flexibleWidth) end

--- LayoutMin.
-- @param o of type GameObject
-- @param minWidth of type Single
-- @param minHeight of type Single
-- @return LayoutElement
function HBU.LayoutMin(o, minWidth, minHeight) end

--- LayoutPreferred.
-- @param o of type GameObject
-- @param preferredWidth of type Single
-- @param preferredHeight of type Single
-- @return LayoutElement
function HBU.LayoutPreferred(o, preferredWidth, preferredHeight) end

--- LayoutFlexible.
-- @param o of type GameObject
-- @param flexibleWidth of type Single
-- @param flexibleHeight of type Single
-- @return LayoutElement
function HBU.LayoutFlexible(o, flexibleWidth, flexibleHeight) end

function HBU.LayoutRect

function HBU.LayoutRect

--- LayoutPadding.
-- @param o of type GameObject
-- @param top of type Single
-- @param left of type Single
-- @param right of type Single
-- @param bottom of type Single
function HBU.LayoutPadding(o, top, left, right, bottom) end

--- OverGUI.
-- @return Boolean
function HBU.OverGUI() end

--- Typing.
-- @return Boolean
function HBU.Typing() end

--- AddComponentLua.
-- @param o of type GameObject
-- @param sctiptName of type String
-- @return LuaComponent
function HBU.AddComponentLua(o, sctiptName) end

--- GetComponentLua.
-- @param o of type GameObject
-- @param scriptName of type String
-- @return LuaComponent
function HBU.GetComponentLua(o, scriptName) end

--- GetComponentsLua.
-- @param o of type GameObject
-- @param scriptName of type String
-- @return LuaComponent[]
function HBU.GetComponentsLua(o, scriptName) end

--- GetComponentInParentLua.
-- @param o of type GameObject
-- @param scriptName of type String
-- @return LuaComponent
function HBU.GetComponentInParentLua(o, scriptName) end

--- GetComponentsInParentLua.
-- @param o of type GameObject
-- @param scriptName of type String
-- @return LuaComponent[]
function HBU.GetComponentsInParentLua(o, scriptName) end

--- GetComponentInChildrenLua.
-- @param o of type GameObject
-- @param scriptName of type String
-- @return LuaComponent
function HBU.GetComponentInChildrenLua(o, scriptName) end

--- GetComponentsInChildrenLua.
-- @param o of type GameObject
-- @param scriptName of type String
-- @return LuaComponent[]
function HBU.GetComponentsInChildrenLua(o, scriptName) end

--- InitLua.
function HBU.InitLua() end

--- LuaInited.
function HBU.LuaInited() end

--- Log.
-- @param text of type String
function HBU.Log(text) end

--- LogError.
-- @param text of type String
function HBU.LogError(text) end

--- LogWarning.
-- @param text of type String
function HBU.LogWarning(text) end

--- GrabStructure.
-- @param root of type GameObject
-- @param addSelf of type Boolean
-- @return GameObject[]
function HBU.GrabStructure(root, addSelf) end

--- HBInstantiate.
-- @param assetPath of type String
-- @return GameObject
function HBU.HBInstantiate(assetPath) end

--- HBSerialize.
-- @param obj of type GameObject
-- @param assetPath of type String
-- @param assetType of type String
-- @param picture of type Texture2D
function HBU.HBSerialize(obj, assetPath, assetType, picture) end

--- UnZip.
-- @param path of type String
-- @param extractPath of type String
function HBU.UnZip(path, extractPath) end

--- ZipFile.
-- @param path of type String
-- @param destinationPath of type String
function HBU.ZipFile(path, destinationPath) end

--- ZipDirectory.
-- @param path of type String
-- @param destinationPath of type String
function HBU.ZipDirectory(path, destinationPath) end

--- Type.
-- @param o of type Object
-- @return String
function HBU.Type(o) end

--- IsRelativeVar.
-- @param target of type GameObject
-- @param o of type Object
-- @return Boolean
function HBU.IsRelativeVar(target, o) end

--- IsRelativeType.
-- @param o of type Object
-- @return Boolean
function HBU.IsRelativeType(o) end

--- IsComponentType.
-- @param o of type Object
-- @return Boolean
function HBU.IsComponentType(o) end

--- IsGameObjectType.
-- @param o of type Object
-- @return Boolean
function HBU.IsGameObjectType(o) end

--- CastVar.
-- @param o of type Object
-- @param target of type Object
-- @return Object
function HBU.CastVar(o, target) end

--- GetIcon.
-- @param p of type String
-- @return Sprite
function HBU.GetIcon(p) end

--- LoadAllIcons.
function HBU.LoadAllIcons() end

--- UnLoadAllIcons.
function HBU.UnLoadAllIcons() end

--- GetLanguage.
-- @return String
function HBU.GetLanguage() end

--- SetLanguage.
-- @param l of type String
function HBU.SetLanguage(l) end

--- GetInfoInLanguage.
-- @param p of type String
-- @param l of type String
-- @return String
function HBU.GetInfoInLanguage(p, l) end

--- GetKeywordInLanguage.
-- @param k of type String
-- @param l of type String
-- @return String
function HBU.GetKeywordInLanguage(k, l) end

--- GetCopyName.
-- @param s of type String
-- @return String
function HBU.GetCopyName(s) end

--- ToUppercase.
-- @param s of type String
-- @return String
function HBU.ToUppercase(s) end

--- ToLowercase.
-- @param s of type String
-- @return String
function HBU.ToLowercase(s) end

--- ToUppercaseFirst.
-- @param s of type String
-- @return String
function HBU.ToUppercaseFirst(s) end

--- ToUppercaseWords.
-- @param value of type String
-- @return String
function HBU.ToUppercaseWords(value) end

--- GetColorFromLinkType.
-- @param linktype of type String
-- @return Color
function HBU.GetColorFromLinkType(linktype) end

--- GetMaterial.
-- @param nam of type String
-- @return Material
function HBU.GetMaterial(nam) end

--- GetMaterialReversedToggle.
-- @param mat of type Material
-- @return Material
function HBU.GetMaterialReversedToggle(mat) end

--- GetMaterialReverse.
-- @param mat of type Material
-- @return Material
function HBU.GetMaterialReverse(mat) end

--- GetMaterialNormal.
-- @param mat of type Material
-- @return Material
function HBU.GetMaterialNormal(mat) end

--- GetMaterialCulling.
-- @param mat of type Material
-- @return Int32
function HBU.GetMaterialCulling(mat) end

