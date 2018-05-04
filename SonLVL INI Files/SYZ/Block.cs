using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.SYZ
{
	class Block : ObjectDefinition
	{
		private Sprite img;
		private List<Sprite> imgs = new List<Sprite>();

		public override void Init(ObjectData data)
		{
			byte[] artfile = ObjectHelper.LevelArt;
			img = ObjectHelper.MapASMToBmp(artfile, "../_maps/Floating Blocks and Doors.asm", 0, 2);
			for (int i = 0; i < 8; i++)
				imgs.Add(ObjectHelper.MapASMToBmp(artfile, "../_maps/Floating Blocks and Doors.asm", i, 2));
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return new ReadOnlyCollection<byte>(new byte[] { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0B, 0x0C }); }
		}

		public override string Name
		{
			get { return "Platform"; }
		}

		public override bool RememberState
		{
			get { return false; }
		}

		public override string SubtypeName(byte subtype)
		{
			return ((PlatformMovement)(subtype & 0xF)).ToString();
		}

		public override Sprite Image
		{
			get { return img; }
		}

		public override Sprite SubtypeImage(byte subtype)
		{
			return imgs[(subtype & 0x70) >> 4];
		}

		public override Sprite GetSprite(ObjectEntry obj)
		{
			Sprite tmp = new Sprite(SubtypeImage(obj.SubType));
			tmp.Flip(obj.XFlip, obj.YFlip);
			return tmp;
		}

		private static readonly PropertySpec[] customProperties = new PropertySpec[] {
			new PropertySpec("Movement", typeof(PlatformMovement), "Extended", null, null, GetMovement, SetMovement),
			new PropertySpec("Switch ID", typeof(int), "Extended", null, null, GetSwitchID, SetSwitchID),
			new PropertySpec("Switch-Controlled", typeof(bool), "Extended", null, null, GetSwitchControl, SetSwitchControl)
		};

		public override PropertySpec[] CustomProperties
		{
			get { return customProperties; }
		}

		public static object GetMovement(ObjectEntry obj)
		{
			return (PlatformMovement)(obj.SubType & 0x0F);
		}

		public static void SetMovement(ObjectEntry obj, object value)
		{
			obj.SubType = (byte)((obj.SubType & ~0x0F) | (int)value);
		}

		public static object GetSwitchID(ObjectEntry obj)
		{
			return (byte)(obj.SubType & 0x0F);
		}

		public static void SetSwitchID(ObjectEntry obj, object value)
		{
			obj.SubType = (byte)((obj.SubType & ~0x0F) | ((byte)value & 0x0F));
		}

		public static object GetSwitchControl(ObjectEntry obj)
		{
			return (obj.SubType & 0x80) != 0 ? true : false;
		}

		public static void SetSwitchControl(ObjectEntry obj, object value)
		{
			obj.SubType = (byte)((obj.SubType & ~0x80) | ((bool)value == true ? 0x80 : 0));
		}
	}

	public enum PlatformMovement
	{
		Stationary,
		RightLeft,
		DownUp,
		FallStand,
		Fall,
		LeftRight,
		UpDown,
		SwitchUp,
		MoveUp,
		Stationary2,
		Invalid1,
		DownUpSlow,
		UpDownSlow,
		Invalid2,
		Invalid3,
		Invalid4
	}
}
