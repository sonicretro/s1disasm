using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.Common
{
    class Spikes : ObjectDefinition
    {
        private Sprite img;
        private List<Sprite> imgs = new List<Sprite>();

        public override void Init(ObjectData data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../artnem/Spikes.bin", Compression.CompressionType.Nemesis);
            img = ObjectHelper.MapASMToBmp(artfile, "../_maps/Spikes.asm", 0, 0);
            Sprite im;
            for (int i = 0; i <= 5; i++)
            {
                im = ObjectHelper.MapASMToBmp(artfile, "../_maps/Spikes.asm", i, 0);
                imgs.Add(im);
            }
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 0x00, 0x01, 0x10, 0x12, 0x20, 0x21, 0x30, 0x31, 0x40, 0x41, 0x50, 0x52 });
        }

        public override string Name()
        {
            return "Spikes";
        }

        public override bool RememberState()
        {
            return false;
        }

        public override string SubtypeName(byte subtype)
        {
            string result = string.Empty;
            switch ((subtype & 0xF0) >> 4)
            {
                case 0:
                    result = "Three Vertical";
                    break;
                case 1:
                    result = "Three Horizontal";
                    break;
                case 2:
                    result = "One Vertical";
                    break;
                case 3:
                    result = "Three Wide Vertical";
                    break;
                case 4:
                    result = "Six Wide Vertical";
                    break;
                case 5:
                    result = "One Horizontal";
                    break;
            }
            result += " " + ((subtype & 3) == 0 ? "Still" : "Moving");
            return result;
        }

        public override BitmapBits Image()
        {
            return img.Image;
        }

        public override BitmapBits Image(byte subtype)
        {
            int frame = subtype >> 4;
            if (frame > 5) frame = 0;
            return imgs[frame].Image;
        }

        public override Rectangle Bounds(ObjectEntry obj, Point camera)
        {
            int frame = obj.SubType >> 4;
            if (frame > 5) frame = 0;
            return new Rectangle(obj.X + imgs[frame].X - camera.X, obj.Y + imgs[frame].Y - camera.Y, imgs[frame].Width, imgs[frame].Height);
        }

        public override Sprite GetSprite(ObjectEntry obj)
        {
            int frame = obj.SubType >> 4;
            if (frame > 5) frame = 0;
            BitmapBits bits = new BitmapBits(imgs[frame].Image);
            bits.Flip(obj.XFlip, obj.YFlip);
            return new Sprite(bits, new Point(obj.X + imgs[frame].X, obj.Y + imgs[frame].Y));
        }

        public override Type ObjectType
        {
            get
            {
                return typeof(SpikesS1ObjectEntry);
            }
        }
    }

    public class SpikesS1ObjectEntry : S1ObjectEntry
    {
        public SpikesS1ObjectEntry() : base() { }
        public SpikesS1ObjectEntry(byte[] file, int address) : base(file, address) { }

        public byte Frame
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

        public Direction Movement
        {
            get
            {
                return (Direction)(SubType & 0xF);
            }
            set
            {
                SubType = (byte)((SubType & ~0xF) | (int)value);
            }
        }

        public enum Direction
        {
            Still,
            Vertical,
            Horizontal
        }
    }
}