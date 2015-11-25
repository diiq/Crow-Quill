import Metal
import UIKit
import QuartzCore

class MetalViewController: UIViewController {
  var device: MTLDevice! = nil
  var metalLayer: CAMetalLayer! = nil
  let vertexData:[Float] = [
    0.0, 1.0, 0.0,
    -1.0, -1.0, 0.0,
    1.0, -1.0, 0.0]
  var vertexBuffer: MTLBuffer! = nil
  var pipelineState: MTLRenderPipelineState! = nil
  var commandQueue: MTLCommandQueue! = nil
  var timer: CADisplayLink! = nil

  override func viewDidLoad() {
    device = MTLCreateSystemDefaultDevice()

    metalLayer = CAMetalLayer()          // 1
    metalLayer.device = device           // 2
    metalLayer.pixelFormat = .BGRA8Unorm // 3
    metalLayer.framebufferOnly = true    // 4
    metalLayer.frame = view.layer.frame  // 5
    view.layer.addSublayer(metalLayer)   // 6

    let dataSize = vertexData.count * sizeofValue(vertexData[0]) // 1
    vertexBuffer = device.newBufferWithBytes(vertexData, length: dataSize, options: .OptionCPUCacheModeDefault) // 2

    let defaultLibrary = device.newDefaultLibrary()
    let fragmentProgram = defaultLibrary!.newFunctionWithName("basic_fragment")
    let vertexProgram = defaultLibrary!.newFunctionWithName("basic_vertex")

    let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
    pipelineStateDescriptor.vertexFunction = vertexProgram
    pipelineStateDescriptor.fragmentFunction = fragmentProgram
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm

    func pipelineError(state: MTLRenderPipelineState?, error : NSError?) {
      if state != nil {
        pipelineState = state
      }
      if error != nil {
        print("Failed to create pipeline state, error \(error!)")
      }
    }

    device.newRenderPipelineStateWithDescriptor(pipelineStateDescriptor, completionHandler: pipelineError)

    commandQueue = device.newCommandQueue()

    timer = CADisplayLink(target: self, selector: Selector("gameloop"))
    timer.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
  }

  func render() {
    let renderPassDescriptor = MTLRenderPassDescriptor()
    let drawable = metalLayer.nextDrawable()!
    renderPassDescriptor.colorAttachments[0].texture = drawable.texture
    renderPassDescriptor.colorAttachments[0].loadAction = .Clear
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 1, green: 1, blue: 1, alpha: 1.0)
    let commandBuffer = commandQueue.commandBuffer()

    let renderEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor)
    renderEncoder.setRenderPipelineState(pipelineState)
    renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
    renderEncoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
    renderEncoder.endEncoding()

    commandBuffer.presentDrawable(drawable)
    commandBuffer.commit()

  }

  func gameloop() {
    autoreleasepool {
      self.render()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func shouldAutorotate() -> Bool {
    return false
  }

  override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.Landscape
  }
}

