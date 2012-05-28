using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.GHZ
{
    class WallBarrier : ObjectDefinition
    {
        private List<Sprite> imgs = new List<Sprite>();

        public override void Init(ObjectData data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../artnem/GHZ Edge Wall.bin", Compression.CompressionType.Nemesis);
            imgs.Add(ObjectHelper.MapASMToBmp(artfile, "../_maps/GHZ Edge Walls.asm", 0, 2));
            imgs.Add(ObjectHelper.MapASMToBmp(artfile, "../_maps/GHZ Edge Walls.asm", 1, 2));
            imgs.Add(ObjectHelper.MapASMToBmp(artfile, "../_maps/GHZ Edge Walls.asm", 2, 2));
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 0x00, 0x01, 0x02, 0x10, 0x11, 0x12 });
        }

        public override string Name()
        {
            return "Wall Barrier";
        }

        public override bool RememberState()
        {
            return true;
        }

        public override string SubtypeName(byte subtype)
        {
            return ((EdgeType)(subtype & 0xF)).ToString();
        }

        public override BitmapBits Image()
        {
            return imgs[0].Image;
        }

        private int imgindex(byte SubType)
        {
            return SubType & 0x3;
        }

        public override BitmapBits Image(byte subtype)
        {
            return imgs[imgindex(subtype)].Image;
        }

        public override Rectangle Bounds(ObjectEntry obj, Point camera)
        {
            return new Rectangle(obj.X +imgs[imgindex(obj.SubType)].X - camera.X, obj.Y + imgs[imgindex(obj.SubType)].Y - camera.Y, imgs[imgindex(obj.SubType)].Width, imgs[imgindex(obj.SubType)].Height);
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
                return typeof(WallBarrierS1ObjectEntry);
            }
        }
    }

    public class WallBarrierS1ObjectEntry : S1ObjectEntry
    {
        public WallBarrierS1ObjectEntry() : base() { }
        public WallBarrierS1ObjectEntry(byte[] file, int address) : base(file, address) { }

        public EdgeType Art
        {
            get
            {
                return (EdgeType)(SubType & 0xF);
            }
            set
            {
                SubType = (byte)((SubType & ~0xF) | (int)value);
            }
        }

        public bool Solid
        {
            get
            {
                return (SubType & 0x10) == 0x10;
            }
            set
            {
                SubType = (byte)((SubType & ~0x10) | (value ? 0x10 : 0));
            }
        }
    }

    public enum EdgeType
    {
        Shadow,
        Light,
        Dark
    }
}