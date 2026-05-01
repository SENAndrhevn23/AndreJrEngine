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

		// Disable Combo Rating Popup
		var option:Option = new Option('Disable Combo Rating Popup',
			'Disables the "Sick!", "Good!", etc. popup when hitting notes.',
			'disableComboRating',
			'bool');
		addOption(option);

		// Disable Combo Number Popup
		var option:Option = new Option('Disable Combo Number Popup',
			'Disables the combo number popup (e.g. 100, 200 combo).',
			'disableComboNumber',
			'bool');
		addOption(option);

		// Disable Combo Popup (both)
		var option:Option = new Option('Disable Combo Popup',
			'Disables all combo popups entirely (rating + numbers).',
			'disableComboPopup',
			'bool');
		addOption(option);

		// Reduced Garbage Collection
		var option:Option = new Option('Reduced Garbage Collection',
			'Reduces how often garbage collection runs.\nMay improve performance but increase memory usage.',
			'reducedGC',
			'bool');
		option.onChange = onChangeGC;
		addOption(option);

		super();
	}

	function onChangeGC()
	{
		#if cpp
		if(ClientPrefs.data.reducedGC)
		{
			// Delay GC a lot (acts like "almost disabled")
			Gc.setMinimumFreeSpace(1024 * 1024 * 128); // 128MB
		}
		else
		{
			// Default behavior
			Gc.setMinimumFreeSpace(0);
		}
		#end
	}
}
