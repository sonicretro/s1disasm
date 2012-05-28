using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.Common
{
    class Spring : ObjectDefinition
    {
        private Sprite img;
        private List<Sprite> imgs = new List<Sprite>();

        public override void Init(ObjectData data)
        {
            byte[] artfile1 = ObjectHelper.OpenArtFile("../artnem/Spring Horizontal.bin", Compression.CompressionType.Nemesis);
            byte[] artfile2 = ObjectHelper.OpenArtFile("../artnem/Spring Vertical.bin", Compression.CompressionType.Nemesis);
            string map = "../_maps/Springs.asm";
            img = ObjectHelper.MapASMToBmp(artfile1, map, 0, 0);
            Sprite im;
            imgs.Add(img); // 0x00
            im = ObjectHelper.MapASMToBmp(artfile1, map, 0, 1); // 0x02
            imgs.Add(im);
            im = ObjectHelper.MapASMToBmp(artfile2, map, 3, 0); // 0x10
            imgs.Add(im);
            im = ObjectHelper.MapASMToBmp(artfile2, map, 3, 1); // 0x12
            imgs.Add(im);
            imgs.Add(imgs[0]); // 0x20
            imgs.Add(imgs[1]); // 0x22
            imgs.Add(imgs[2]); // 0x30
            imgs.Add(imgs[3]); // 0x32
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 0x00, 0x02, 0x10, 0x12, 0x20, 0x22, 0x30, 0x32 });
        }

        public override string Name()
        {
            return "Spring";
        }

        public override bool RememberState()
        {
            return false;
        }

        public override string SubtypeName(byte subtype)
        {
            string result = ((SpringColor)((subtype & 2) >> 1)).ToString();
            return result;
        }

        public override BitmapBits Image()
        {
            return img.Image;
        }

        private int imgindex(byte subtype)
        {
            int result = (subtype & 2) >> 1;
            result |= (subtype & 0x30) >> 3;
            return result;
        }

        public override BitmapBits Image(byte subtype)
        {
            return imgs[imgindex(subtype)].Image;
        }

        public override Rectangle Bounds(ObjectEntry obj, Point camera)
        {
            return new Rectangle(obj.X + imgs[imgindex(obj.SubType)].X - camera.X, obj.Y + imgs[imgindex(obj.SubType)].Y - camera.Y, imgs[imgindex(obj.SubType)].Width, imgs[imgindex(obj.SubType)].Height);
        }

        public override Sprite GetSprite(ObjectEntry obj)
        {
            BitmapBits bits = new BitmapBits(imgs[imgindex(obj.SubType)].Image);
            bits.Flip(obj.XFlip, obj.YFlip);
            return new Sprite(bits, new Point(obj.X + imgs[imgindex(obj.SubType)].Offset.X, obj.Y + imgs[imgindex(obj.SubType)].Offset.Y));
        }

        public override Type ObjectType
        {
            get
            {
                return typeof(SpringS1ObjectEntry);
            }
        }
    }

    public class SpringS1ObjectEntry : S1ObjectEntry
    {
        public SpringS1ObjectEntry() : base() { }
        public SpringS1ObjectEntry(byte[] file, int address) : base(file, address) { }

        public SpringDirection Direction
        {
            get
            {
                return (SpringDirection)((SubType & 0x30) >> 4);
            }
            set
            {
                SubType = (byte)((SubType & ~0x30) | ((int)value << 4));
            }
        }

        public SpringColor Color
        {
            get
            {
                return (SpringColor)((SubType & 2) >> 1);
            }
            set
            {
                SubType = (byte)((SubType & ~2) | ((int)value << 1));
            }
        }
    }

    public enum SpringDirection
    {
        Up,
        Horizontal,
        Down,
        Horizontal2
    }

    public enum SpringColor
    {
        Red,
        Yellow
    }
}