package topo;

import iso.IsoSortable;
import bitdecay.flixel.debug.DebugDraw;
import debug.DebugLayers;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import iso.Grid;
import iso.IsoSprite;
import iso.Overlap;

class Topographic extends FlxBasic {
	public var objects:Array<IsoSortable>;

	public var rootNodes:Array<TNode>;
	public var allNodes:Array<TNode>;

	public function new(objs:Array<IsoSortable>) {
		super();

		objects = objs;
		rebuild();
	}

	public function add(o:IsoSortable) {
		objects.push(o);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		for (o in objects) {
			o.update(elapsed);
		}
		rootNodes.sort((rn1, rn2) -> {
			return rn1.children.length - rn2.children.length;
		});
	}

	override function draw() {
		super.draw();
		for (root in rootNodes) {
			root.draw();
		}
	}

	public function drawDebug() {
		for (root in rootNodes) {
			drawGraphBranch(root, root.color);
		}
	}

	private function drawGraphBranch(n:TNode, color:FlxColor = FlxColor.ORANGE, size:Float = 3) {
		if (n.children.length == 0) {
			// return;
		}

		var p = n.object.centerPoint();
		Grid.gridToIso(p.x, p.y, p);
		DebugDraw.ME.drawWorldCircle(p.x, p.y, size, DebugLayers.GRAPH, color);

		var t = FlxPoint.get();
		for (c in n.children) {
			c.object.centerPoint(t);
			Grid.gridToIso(t.x, t.y, t);
			DebugDraw.ME.drawWorldLine(p.x, p.y, t.x, t.y, DebugLayers.GRAPH, color);

			// var arrowHead = FlxPoint.get().copyFrom(t).subtractPoint(p).rightNormal().pivotDegrees(t, 45).addPoint(t);
			var arrowHead = FlxPoint.get()
				.copyFrom(t)
				.subtractPoint(p)
				.rotateByDegrees(165)
				.normalize()
				.scale(3)
				.addPoint(t);

			drawGraphBranch(c, color.getDarkened(.1), Math.max(0, size - 0.5));
			// draw last so it is on top of the children circles
			DebugDraw.ME.drawWorldLine(t.x, t.y, arrowHead.x, arrowHead.y, DebugLayers.GRAPH, FlxColor.WHITE);
		}
	}

	public function rebuild() {
		TNode.index = 0;
		rootNodes = [];
		allNodes = [];

		for (o in objects) {
			allNodes.push(new TNode(o));
		}

		// build all of our knowledge of parents and children.
		// This may create multiple small graphs as only some objects
		// are overlapping
		for (node in allNodes) {
			for (n in allNodes) {
				if (node.object == n.object) {
					continue;
				}

				if (Overlap.doSpritesOverlapInIsoSpace(node.object, n.object)) {
					if (Overlap.isSpriteInFront(n.object, node.object)) {
						node.children.push(n);
						n.parents.push(node);
					}
				}
			}
		}

		for (node in allNodes) {
			if (node.parents.length == 0) {
				rootNodes.push(node);
			}
		}
	}
}

class TNode {
	public var color:FlxColor;
	public var visited = false;
	public var parents:Array<TNode>;
	public var children:Array<TNode>;
	public var object:IsoSortable;
	public var drawn:Bool = false;

	private static var colors = [
		for (i in 0...5) {
			FlxColor.fromHSL(FlxG.random.int(0, 360), FlxG.random.float(.5, 1), FlxG.random.float(.4, .8));
		}
	];
	public static var index = 0;

	public function new(o:IsoSortable) {
		object = o;
		parents = [];
		children = [];

		// for debugging. Likely should put this behind a compilation flag
		index = index % colors.length;
		color = colors[index++];
	}

	public function draw() {
		if (drawn) {
			return;
		}


		object.draw();
		for (c in children) {
			// This may not work properly. Need to traverse this graph more intelligently
			// to avoid drawing things early
			c.draw();
		}
		drawn = true;
	}
}
