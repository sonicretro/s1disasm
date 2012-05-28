using System;
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

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0B, 0x0C });
        }

        public override string Name()
        {
            return "Platform";
        }

        public override bool RememberState()
        {
            return false;
        }

        public override string SubtypeName(byte subtype)
        {
            return ((PlatformMovement)(subtype & 0xF)).ToString();
        }

        public override BitmapBits Image()
        {
            return img.Image;
        }

        public override BitmapBits Image(byte subtype)
        {
            return imgs[(subtype & 0xE) << 1].Image;
        }

        public override Rectangle Bounds(ObjectEntry obj, Point camera)
        {
            return new Rectangle(obj.X + imgs[(obj.SubType & 0xE) << 1].X - camera.X, obj.Y + imgs[(obj.SubType & 0xE) << 1].Y - camera.Y, imgs[(obj.SubType & 0xE) << 1].Width, imgs[(obj.SubType & 0xE) << 1].Height);
        }

        public override Sprite GetSprite(ObjectEntry obj)
        {
            BitmapBits bits = new BitmapBits(imgs[(obj.SubType & 0xE) << 1].Image);
            bits.Flip(obj.XFlip, obj.YFlip);
            return new Sprite(bits, new Point(obj.X + imgs[(obj.SubType & 0xE) << 1].X, obj.Y + imgs[(obj.SubType & 0xE) << 1].Y));
        }

        public override Type ObjectType
        {
            get
            {
                return typeof(BlockS1ObjectEntry);
            }
        }
    }

    public class BlockS1ObjectEntry : S1ObjectEntry
    {
        public BlockS1ObjectEntry() : base() { }
        public BlockS1ObjectEntry(byte[] file, int address) : base(file, address) { }

        public PlatformMovement Movement
        {
            get
            {
                return (PlatformMovement)(SubType & 0xF);
            }
            set
            {
                SubType = (byte)((SubType & ~0xF) | (int)value);
            }
        }

        public byte SwitchID
        {
            get
            {
                return (byte)(SubType >> 4);
            }
            set
            {
                SubType = (byte)((SubType & ~0xF0) | (value << 4));
            }
        }
    }

    public enum PlatformMovement2
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