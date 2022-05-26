/*
 * generated by Xtext 2.25.0
 */
package xtext.factoryLang.scoping

import org.eclipse.xtext.scoping.IScope
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import xtext.factoryLang.factoryLang.FactoryLangPackage.Literals
import org.eclipse.xtext.EcoreUtil2
import xtext.factoryLang.factoryLang.DiskOperation
import xtext.factoryLang.factoryLang.Model
import org.eclipse.xtext.scoping.Scopes
import xtext.factoryLang.factoryLang.Operation
import xtext.factoryLang.factoryLang.CraneOperation
import xtext.factoryLang.factoryLang.CameraScanOperation
import xtext.factoryLang.factoryLang.ForEach
import xtext.factoryLang.factoryLang.DeviceConditional
import xtext.factoryLang.factoryLang.DeviceValue

/**
 * This class contains custom scoping description.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#scoping
 * on how and when to use it.
 */
class FactoryLangScopeProvider extends AbstractFactoryLangScopeProvider {

	override IScope getScope(EObject context, EReference reference) {
		switch (reference) {
			case Literals.CRANE_OPERATION__TARGET,
			case Literals.DISK_MOVE_SLOT_OPERATION__SOURCE,
			case Literals.DISK_MOVE_SLOT_OPERATION__TARGET,
			case Literals.DISK_MOVE_VARIABLE_SLOT_OPERATION__TARGET,
			case Literals.DISK_MOVE_EMPTY_SLOT_OPERATION__TARGET,
			case Literals.DISK_MARK_SLOT_OPERATION__TARGET:
				return getOperationTargetScope(context as Operation)
			case Literals.DISK_MOVE_VARIABLE_SLOT_OPERATION__VARIABLE,
			case Literals.VARIABLE_CONDITIONAL__VARIABLE:
				return getVariableScope(context, context)
			case Literals.DEVICE_VALUE__REF:
				return getDeviceValueRefScope(context as DeviceValue)
		}
		return super.getScope(context, reference)
	}

	def IScope getVariableScope(EObject currentContext, EObject context) {
		val parent = currentContext.eContainer
		val nextForEach = EcoreUtil2.getContainerOfType(parent, ForEach);

		if (nextForEach !== null)
			return Scopes.scopeFor(#[nextForEach.variable], getVariableScope(nextForEach, context));
		return getGlobalRefValueScope(context)
	}

	def IScope getOperationTargetScope(Operation operation) {
		val root = EcoreUtil2.getRootContainer(operation) as Model
		var tempDeviceName = ""
		switch (operation) {
			case operation instanceof CraneOperation: // xtend is little bitch
				tempDeviceName = (operation as CraneOperation).device.name
			case operation instanceof DiskOperation:
				tempDeviceName = (operation as DiskOperation).device.name
		}
		val deviceName = tempDeviceName // xtend is more little bitch
		val device = root.configuration.devices.filter[it.name == deviceName].map[it].toList
		val targets = device.get(0).targets

		return Scopes.scopeFor(targets)
	}

	// forward declaration does not work
	def IScope getGlobalRefValueScope(EObject context) {
		val root = EcoreUtil2.getRootContainer(context) as Model
		val cameraScanOperations = EcoreUtil2.getAllContentsOfType(root, CameraScanOperation).map[variable].toList
		// Scopes.index(context,)
		// ExpressionsModelUtil.
		return Scopes.scopeFor(cameraScanOperations);
	}

	// auto-complete does not work with this, but scoping does
	def IScope getDeviceValueRefScope(DeviceValue deviceValue) {
		val deviceConditional = EcoreUtil2.getContainerOfType(deviceValue, DeviceConditional)
		val deviceName = deviceConditional.device.name

		val root = EcoreUtil2.getRootContainer(deviceValue) as Model
		val device = root.configuration.devices.filter[it.name == deviceName].map[it].get(0)
		var targets = device.targets
		return Scopes.scopeFor(targets)
	}
}
