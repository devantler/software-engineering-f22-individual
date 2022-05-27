package xtext.factoryLang.generator.uppaal

import java.util.List
import xtext.factoryLang.factoryLang.Camera
import xtext.factoryLang.factoryLang.Crane
import xtext.factoryLang.factoryLang.CranePositionParameter
import xtext.factoryLang.factoryLang.Disk
import xtext.factoryLang.factoryLang.UppaalQuery
import xtext.factoryLang.factoryLang.AllPathsUppaalQuery
import xtext.factoryLang.factoryLang.OnePathUppaalQuery
import xtext.factoryLang.factoryLang.LeadsToUppaalQuery
import xtext.factoryLang.factoryLang.Expression
import xtext.factoryLang.factoryLang.Or
import xtext.factoryLang.factoryLang.And
import xtext.factoryLang.factoryLang.Imply
import xtext.factoryLang.factoryLang.Parenthesis
import xtext.factoryLang.factoryLang.DeviceState

class UppaalQueryGenerator {
	def static String generateUpaalQuery(List<Crane> cranes, List<Disk> discs, List<Camera> cameras,
		List<UppaalQuery> queries) {
		return '''
			<queries>
			   «FOR crane : cranes»
			   	<query>
				<formula>A&lt;&gt; «crane.name»_CraneMagnet.«crane.name»_MagnetOn imply «crane.name»_CraneMagnet.«crane.name»_MagnetOff</formula>
				<comment></comment>
				</query>
				«FOR position: crane.targets»
					<query>
						<formula>A[] («crane.name».«crane.name»_«(position as CranePositionParameter).name» and «crane.name»_CraneMagnet.«crane.name»_MagnetOff) imply !(«crane.name».«crane.name»_«(position as CranePositionParameter).name» and «crane.name»_CraneMagnet.«crane.name»_MagnetOn)</formula>
						<comment></comment>
					</query>
					<query>
						<formula>A[] («crane.name».«crane.name»_«(position as CranePositionParameter).name» and «crane.name»_CraneMagnet.«crane.name»_MagnetOn) imply !(«crane.name».«crane.name»_«(position as CranePositionParameter).name» and «crane.name»_CraneMagnet.«crane.name»_MagnetOff)</formula>
						<comment></comment>
					</query>
				«ENDFOR»
				<query>
					<formula>A[] (EmergencyButton.Stopped and «crane.name»_CraneMagnet.«crane.name»_MagnetOn) imply «crane.name»_CraneMagnet.«crane.name»_StoppedMagnetOn</formula>
					<comment></comment>
				</query>
			«ENDFOR»
			<query>
				<formula>A[] !deadlock or EmergencyButton.Stopped</formula>
				<comment></comment>
			</query>
			«FOR disc : discs»
				<query>
					<formula>A[] !«disc.name»_notcompleteSlots[1] imply «disc.name»_notemptySlots[1]</formula>
					<comment></comment>
				</query>
				<query>
					<formula>E&lt;&gt; forall (i : «disc.name»_id_t) «disc.name»_DiscSlot(i).«disc.name»_SlotEmpty</formula>
					<comment></comment>
				</query>
				«FOR crane: cranes»
					<query>
						<formula>A[] EmergencyButton.Stopped imply («crane.name».«crane.name»_Stopped and «disc.name».Stopped and («crane.name»_CraneMagnet.«crane.name»_StoppedMagnetOff or «crane.name»_CraneMagnet.«crane.name»_StoppedMagnetOn))</formula>
						<comment></comment>
					</query>
				«ENDFOR»
			«ENDFOR»
			«FOR query : queries»
				«generateDynamicQuery(query)»
			«ENDFOR»
			</queries>
			</nta>
		'''
	/* Removed for now
	 *  					<query>
	 * 				<formula>A[] MasterController.gotoIntake_crane imply «disc.name»slots_finished[currentSlot_finished]</formula>
	 * 				<comment></comment>
	 * 			</query>
	 */
	}

	def static generateDynamicQuery(UppaalQuery query) {
		switch query {
			AllPathsUppaalQuery: '''
				<query>
					<formula>A«parseProperty(query.property)» «parseExpression(query.expression.expression)»</formula>
					<comment></comment>
				</query>
			'''
			OnePathUppaalQuery: '''
				<query>
					<formula>E«parseProperty(query.property)» «parseExpression(query.expression.expression)»</formula>
					<comment></comment>
				</query>
			'''
			LeadsToUppaalQuery: '''
				<query>
					<formula>«parseExpression(query.stateOne)» --> «parseExpression(query.stateTwo)»</formula>
					<comment></comment>
				</query>
			'''
		}
	}

	def static parseExpression(Expression expression) {
		switch expression {
			Or: '''«parseExpression(expression.left)» or «parseExpression(expression.right)»'''
			And: '''«parseExpression(expression.left)» and «parseExpression(expression.right)»'''
			Imply: '''«parseExpression(expression.left)» imply «parseExpression(expression.right)»'''
			Parenthesis: '''(«parseExpression(expression.parenthesizedExpression)»)'''
			DeviceState: '''«expression.device.name».«expression.location»'''
		}
	}

	def static parseProperty(String property) {
		switch property {
			case "forever": "[]"
			case "eventually": "<>"
		}
	}

}
