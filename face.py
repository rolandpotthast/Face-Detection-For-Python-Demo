from pathlib import Path

import PIL
import typer
from fdlite import FaceDetection, FaceDetectionModel
from fdlite.render import Colors, detections_to_render_data, render_to_image


def detect_faces(image: PIL.Image.Image):
    detector = FaceDetection(model_type=FaceDetectionModel.BACK_CAMERA)
    faces = detector(image)
    print(f"Found {len(faces)} faces")
    return faces


def mark_faces(image_filename: Path):
    """Mark all faces recognized in the image."""
    image = PIL.Image.open(image_filename)

    faces = detect_faces(image)

    render_data = detections_to_render_data(
        faces, bounds_color=Colors.GREEN, line_width=3
    )
    render_to_image(render_data, image)

    out_file = image_filename.with_name(image_filename.stem + "_out.jpg")
    image.save(out_file)
    print(f"Saved: {out_file}")


if __name__ == "__main__":
    typer.run(mark_faces)
