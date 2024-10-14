package mikolka.compatibility;

import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import haxe.io.Path;

using mikolka.funkin.utils.ArrayTools;

class ModsHelper {
	public inline static function isModDirEnabled(directory:String) {
		return getEnabledMods().contains(directory);
	}
    public inline static function loadModDir(directory:String) {
		Paths.currentModDirectory = directory;
	}
	public static function getModsWithPlayersRegistry():Array<String> {
		return getEnabledMods().filter(s ->FileSystem.exists(Paths.mods(s)+'/registry/players'));
	}
	public inline static function loadabsoluteGraphic(path:String):FlxGraphic {
		if(!Paths.currentTrackedAssets.exists(path)) {
			Paths.currentTrackedAssets.set(path,FlxGraphic.fromBitmapData(BitmapData.fromFile(path)));
		}
		return Paths.currentTrackedAssets.get(path);
	}
	private static function getEnabledMods(){
		var folders = [];
		var path:String = 'modsList.txt';
		if(FileSystem.exists(path))
		{
			var list:Array<String> = CoolUtil.coolTextFile(path);
			for (i in list)
			{
				var dat = i.split("|");
				if (dat[1] == "1")
				{
					if(!folders.contains(dat[0])) folders.push(dat[0]);
				}
			}
		}
		return folders;
	}
	public inline static function getSoundChannel(sound:FlxSound){
		@:privateAccess
		return sound._channel.__source;
	}
	public static function clearStoredWithoutStickers() {
		@:privateAccess
		var cache = FlxG.bitmap._cache;
		for (key => val in cache){
		if(key.toLowerCase().contains("transitionswag") || key.contains("bg_graphic_")) Paths.currentTrackedAssets.set(key,val);
		}
		Paths.clearStoredMemory();
	}
	#if sys
	public inline static function collectVideos():String{
		var dirsToList = new Array<String>();
		dirsToList.push('assets/videos/commercials/');
		if(FileSystem.exists('mods/videos/commercials'))dirsToList.push('mods/videos/commercials/');
		WeekData.loadTheFirstEnabledMod();
		var modsToSearch = Paths.getGlobalMods();
		modsToSearch.pushUnique(Paths.currentModDirectory);
		modsToSearch = modsToSearch.filter(s -> FileSystem.exists('mods/$s/videos/commercials')).map(s -> 'mods/$s/videos/commercials');
		
		dirsToList = dirsToList.concat(modsToSearch);
		var commercialsToSelect = new Array<String>();
		for(potencialComercials in dirsToList){
		  for (file in FileSystem.readDirectory(potencialComercials).filter(s -> s.endsWith(".mp4"))) {
			commercialsToSelect.push(potencialComercials + '/'+file);
		  }
		}
		return FlxG.random.getObject(commercialsToSelect);
	  }
	#end
}