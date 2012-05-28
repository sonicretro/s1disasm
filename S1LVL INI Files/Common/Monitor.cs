using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.Common
{
    class Monitor : ObjectDefinition
    {
        private int[] labels = { 1, 3, 4, 5, 6, 7, 8, 9, 10, 11 };
        private Sprite img;
        private List<Sprite> imgs = new List<Sprite>();

        public override void Init(ObjectData data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../artnem/Monitors.bin", Compression.CompressionType.Nemesis);
            img = ObjectHelper.MapASMToBmp(artfile, "../_maps/Monitor.asm", 0, 0);
            for (int i = 0; i < 10; i++)
                imgs.Add(ObjectHelper.MapASMToBmp(artfile, "../_maps/Monitor.asm", labels[i], 0));
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 });
        }

        public override string Name()
        {
            return "Monitor";
        }

        public override bool RememberState()
        {
            return true;
        }

        public override string SubtypeName(byte subtype)
        {
            switch (subtype)
            {
                case 0:
                    return "Static";
                case 1:
                    return "Eggman";
                case 2:
                    return "Sonic";
                case 3:
                    return "Shoes";
                case 4:
                    return "Shield";
                case 5:
                    return "Invincibility";
                case 6:
                    return "Rings";
                case 7:
                    return "S";
                case 8:
                    return "Goggles";
                case 9:
                    return "Broken";
                default:
                    return "Invalid";
            }
        }

        public override BitmapBits Image()
        {
            return img.Image;
        }

        public override BitmapBits Image(byte subtype)
        {
            if (subtype <= 9)
                return imgs[subtype].Image;
            else
                return img.Image;
        }

        public override Rectangle Bounds(ObjectEntry obj, Point camera)
        {
            if (obj.SubType <= 9)
                return new Rectangle(obj.X + imgs[obj.SubType].X - camera.X, obj.Y + imgs[obj.SubType].Y - camera.Y, imgs[obj.SubType].Width, imgs[obj.SubType].Height);
            else
                return new Rectangle(obj.X + img.X - camera.X, obj.Y + img.Y - camera.Y, img.Width, img.Height);
        }

        public override Sprite GetSprite(ObjectEntry obj)
        {
            byte subtype = obj.SubType;
            if (subtype > 9) subtype = 0;
            BitmapBits bits = new BitmapBits(imgs[subtype].Image);
            bits.Flip(obj.XFlip, obj.YFlip);
            return new Sprite(bits, new Point(obj.X + imgs[subtype].Offset.X, obj.Y + imgs[subtype].Offset.Y));
        }

        public override Type ObjectType { get { return typeof(MonitorS1ObjectEntry); } }
    }

    public class MonitorS1ObjectEntry : S1ObjectEntry
    {
        public MonitorS1ObjectEntry() : base() { }
        public MonitorS1ObjectEntry(byte[] file, int address) : base(file, address) { }

        public MonitorType Contents
        {
            get
            {
                if (SubType > 9) return MonitorType.Invalid;
                return (MonitorType)SubType;
            }
            set
            {
                SubType = (byte)value;
            }
        }
    }

    public enum MonitorType
    {
        Static,
        Eggman,
        Sonic,
        Shoes,
        Shield,
        Invincibility,
        Rings,
        S,
        Goggles,
        Broken,
        Invalid
    }
}