using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S1ObjectDefinitions.GHZ
{
    class BreakableWall : ObjectDefinition
    {
        private int[] labels = { 0, 1, 2 };
        private Sprite img;
        private List<Sprite> imgs = new List<Sprite>();

        public override void Init(ObjectData data)
        {
            byte[] artfile = ObjectHelper.OpenArtFile("../artnem/GHZ Breakable Wall.bin", Compression.CompressionType.Nemesis);
            img = ObjectHelper.MapASMToBmp(artfile, "../_maps/Smashable Walls.asm", 0, 2);
            for (int i = 0; i < labels.Length; i++)
                imgs.Add(ObjectHelper.MapASMToBmp(artfile, "../_maps/Smashable Walls.asm", labels[i], 2));
        }

        public override ReadOnlyCollection<byte> Subtypes()
        {
            return new ReadOnlyCollection<byte>(new byte[] { 0x00, 0x01, 0x02 });
        }

        public override string Name()
        {
            return "Breakable Wall";
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
                    return "Left";
                case 1:
                    return "Middle";
                case 2:
                    return "Right";
                default:
                    return string.Empty;
            }
        }

        public override BitmapBits Image()
        {
            return img.Image;
        }

        public override BitmapBits Image(byte subtype)
        {
            if (subtype < labels.Length)
                return imgs[subtype].Image;
            else
                return img.Image;
        }

        public override Rectangle Bounds(ObjectEntry obj, Point camera)
        {
            if (obj.SubType < labels.Length)
                return new Rectangle(obj.X + imgs[obj.SubType].X - camera.X, obj.Y + imgs[obj.SubType].Y - camera.Y, imgs[obj.SubType].Width, imgs[obj.SubType].Height);
            else
                return new Rectangle(obj.X + img.X - camera.X, obj.Y + img.Y - camera.Y, img.Image.Width, img.Image.Height);
        }

        public override Sprite GetSprite(ObjectEntry obj)
        {
            byte subtype = obj.SubType;
            if (subtype > labels.Length) subtype = 0;
            BitmapBits bits = new BitmapBits(imgs[subtype].Image);
            bits.Flip(obj.XFlip, obj.YFlip);
            return new Sprite(bits, new Point(obj.X + imgs[subtype].Offset.X, obj.Y + imgs[subtype].Offset.Y));
        }
    }
}