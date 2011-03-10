using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Drawing;
using Extensions;
using S2LVL;

namespace S1ObjectDefinitions.Common
{
    class Spikes : ObjectDefinition
    {
        private Point offset;
        private Bitmap img;
        private int imgw, imgh;
        private List<Point> offsets = new List<Point>();
        private List<Bitmap> imgs = new List<Bitmap>();
        private List<int> imgws = new List<int>();
        private List<int> imghs = new List<int>();

        public override void Init(Dictionary<string, string> data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../artnem/Spikes.bin", Compression.CompressionType.Nemesis);
            img = ObjectHelper.MapASMToBmp(artfile, "../_maps/Spikes.asm", "byte_CFF4", 0, out offset);
            imgw = img.Width;
            imgh = img.Height;
            Point off;
            Bitmap im;
            im = ObjectHelper.MapASMToBmp(artfile, "../_maps/Spikes.asm", "byte_CFF4", 0, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            im = ObjectHelper.MapASMToBmp(artfile, "../_maps/Spikes.asm", "byte_D004", 0, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            im = ObjectHelper.MapASMToBmp(artfile, "../_maps/Spikes.asm", "byte_D014", 0, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            im = ObjectHelper.MapASMToBmp(artfile, "../_maps/Spikes.asm", "byte_D01A", 0, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            im = ObjectHelper.MapASMToBmp(artfile, "../_maps/Spikes.asm", "byte_D02A", 0, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
            im = ObjectHelper.MapASMToBmp(artfile, "../_maps/Spikes.asm", "byte_D049", 0, out off);
            imgs.Add(im);
            offsets.Add(off);
            imgws.Add(im.Width);
            imghs.Add(im.Height);
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

        public override string FullName(byte subtype)
        {
            return SubtypeName(subtype) + " " + Name();
        }

        public override Bitmap Image()
        {
            return img;
        }

        public override Bitmap Image(byte subtype)
        {
            int frame = subtype >> 4;
            if (frame > 5) frame = 0;
            return imgs[frame];
        }

        public override void Draw(Graphics gfx, Point loc, byte subtype, bool XFlip, bool YFlip)
        {
            int frame = subtype >> 4;
            if (frame > 5) frame = 0;
            gfx.DrawImageFlipped(imgs[frame], loc.X + offsets[frame].X, loc.Y + offsets[frame].Y, XFlip, YFlip);
        }

        public override Rectangle Bounds(Point loc, byte subtype)
        {
            int frame = subtype >> 4;
            if (frame > 5) frame = 0;
            return new Rectangle(loc.X + offsets[frame].X, loc.Y + offsets[frame].Y, imgws[frame], imghs[frame]);
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