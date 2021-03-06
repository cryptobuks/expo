package abi26_0_0.host.exp.exponent.modules.api.components.camera.tasks;

import android.util.SparseArray;

import com.google.android.gms.vision.face.Face;

import abi26_0_0.host.exp.exponent.modules.api.components.facedetector.ExpoFaceDetector;
import abi26_0_0.host.exp.exponent.modules.api.components.facedetector.ExpoFrame;
import abi26_0_0.host.exp.exponent.modules.api.components.facedetector.ExpoFrameFactory;

public class FaceDetectorAsyncTask extends android.os.AsyncTask<Void, Void, SparseArray<Face>> {
  private byte[] mImageData;
  private int mWidth;
  private int mHeight;
  private int mRotation;
  private ExpoFaceDetector mFaceDetector;
  private FaceDetectorAsyncTaskDelegate mDelegate;

  public FaceDetectorAsyncTask(
      FaceDetectorAsyncTaskDelegate delegate,
      ExpoFaceDetector faceDetector,
      byte[] imageData,
      int width,
      int height,
      int rotation
  ) {
    mImageData = imageData;
    mWidth = width;
    mHeight = height;
    mRotation = rotation;
    mDelegate = delegate;
    mFaceDetector = faceDetector;
  }

  @Override
  protected SparseArray<Face> doInBackground(Void... ignored) {
    if (isCancelled() || mDelegate == null || mFaceDetector == null || !mFaceDetector.isOperational()) {
      return null;
    }

    ExpoFrame frame = ExpoFrameFactory.buildFrame(mImageData, mWidth, mHeight, mRotation);
    return mFaceDetector.detect(frame);
  }

  @Override
  protected void onPostExecute(SparseArray<Face> faces) {
    super.onPostExecute(faces);

    if (faces == null) {
      mDelegate.onFaceDetectionError(mFaceDetector);
    } else {
      mDelegate.onFacesDetected(faces, mWidth, mHeight, mRotation);
      mDelegate.onFaceDetectingTaskCompleted();
    }
  }
}
