package options;

#if cpp
import cpp.vm.Gc;
#end

class OptimizationsSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Optimizations';
		rpcTitle = 'Optimizations Settings Menu';

		// ---------------- COMBO SETTINGS ----------------

		var option:Option = new Option(
			'Show Rating Popup',
			'Shows "Sick!", "Good!", etc when hitting notes.',
			'showRating',
			'bool'
		);
		addOption(option);

		var option:Option = new Option(
			'Show Combo Numbers',
			'Shows combo numbers (100, 200, etc).',
			'showComboNum',
			'bool'
		);
		addOption(option);

		var option:Option = new Option(
			'Show Combo Popup',
			'Shows full combo popup (rating + numbers).',
			'showCombo',
			'bool'
		);
		addOption(option);

		// ---------------- PERFORMANCE ----------------

		var option:Option = new Option(
			'Low Quality Mode',
			'Disables extra visual effects to improve performance.',
			'lowQuality',
			'bool'
		);
		addOption(option);

		var option:Option = new Option(
			'Reduced Garbage Collection',
			'Reduces GC frequency for smoother gameplay.\nMay increase memory usage.',
			'reducedGC',
			'bool'
		);
		option.onChange = onChangeGC;
		addOption(option);

		// ---------------- GC MEMORY LIMIT (NEW) ----------------

		var option:Option = new Option(
			'GC Memory Limit',
			'Controls GC memory pressure in MB.\nLower = more cleanup, higher = smoother gameplay.',
			'',
			'int'
		);
		option.minValue = 64;
		option.maxValue = 1024;
		option.displayFormat = '%v MB';
		option.onChange = onChangeGC;
		addOption(option);

		super();
	}

	// ---------------- GC HANDLER ----------------

	function onChangeGC()
	{
		#if cpp
		if (ClientPrefs.data.reducedGC)
		{
			var mb = ClientPrefs.data.;
			if (mb < 64) mb = 64;

			Gc.setMinimumFreeSpace(mb * 1024 * 1024);
		}
		else
		{
			// default GC behavior
			Gc.setMinimumFreeSpace(0);
		}
		#end
	}
}