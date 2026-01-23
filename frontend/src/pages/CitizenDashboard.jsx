import React, { useState, useEffect } from 'react'
import { Layout } from '../components/common/Layout'
import { Card } from '../components/common/Card'
import { Alert } from '../components/common/Alert'
import ScoreGauge from '../components/ScoreGauge'
import TransactionUpload from '../components/citizen/TransactionUpload'
import { api } from '../services/api'

export default function CitizenDashboard({ user, onLogout }) {
    const [scoreData, setScoreData] = useState(null)

    const handleScoreUpdate = (data) => {
        setScoreData(data)
    }

    return (
        <Layout user={user} onLogout={onLogout}>
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                {/* Left Column: Score & Summary */}
                <div className="lg:col-span-1 space-y-8">
                    <Card className="text-center h-full flex flex-col items-center relative overflow-hidden">
                        {scoreData && scoreData.reward_eligible && (
                            <div className="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-green-400 to-blue-500" />
                        )}

                        <h2 className="text-xl font-semibold mb-6 text-slate-800">Your Credit Health</h2>

                        <div className="flex justify-center mb-6 relative">
                            {scoreData ? (
                                <>
                                    <ScoreGauge score={scoreData.score} category={scoreData.category} />
                                    {/* Trend Indicator */}
                                    <div className={`absolute -right-4 top-1/2 transform -translate-y-1/2 flex flex-col items-center ${scoreData.trend === 'improving' ? 'text-green-500' :
                                            scoreData.trend === 'declining' ? 'text-red-500' : 'text-slate-400'
                                        }`}>
                                        {scoreData.trend === 'improving' && (
                                            <>
                                                <svg className="w-8 h-8 animate-bounce" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
                                                </svg>
                                                <span className="text-xs font-bold uppercase">Trending Up</span>
                                            </>
                                        )}
                                        {scoreData.trend === 'declining' && (
                                            <>
                                                <svg className="w-8 h-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 17h8m0 0V9m0 8l-8-8-4 4-6-6" />
                                                </svg>
                                                <span className="text-xs font-bold uppercase">Trending Down</span>
                                            </>
                                        )}
                                    </div>
                                </>
                            ) : (
                                <div className="w-64 h-64 rounded-full border-8 border-slate-100 flex items-center justify-center text-slate-300">
                                    <span className="text-lg">No Data</span>
                                </div>
                            )}
                        </div>

                        {scoreData && (
                            <div className="text-center w-full px-4">
                                <div className="mt-4 p-4 bg-slate-50 rounded-xl text-left border border-slate-100">
                                    <p className="text-sm text-slate-600 leading-relaxed italic">
                                        "{scoreData.recommendations.narrative}"
                                    </p>
                                </div>
                            </div>
                        )}

                        {!scoreData && (
                            <p className="text-slate-500 text-sm mt-4">Upload transactions to generate your score</p>
                        )}
                    </Card>
                </div>

                {/* Right Column: Actions & Details */}
                <div className="lg:col-span-2 space-y-6">
                    {!scoreData && (
                        <Card title="Get Started">
                            <div className="space-y-4">
                                <TransactionUpload onScoreUpdate={handleScoreUpdate} />
                                <div className="relative flex py-2 items-center">
                                    <div className="flex-grow border-t border-gray-200"></div>
                                    <span className="flex-shrink-0 mx-4 text-gray-400 text-sm">Or try demo data</span>
                                    <div className="flex-grow border-t border-gray-200"></div>
                                </div>
                                <button
                                    onClick={async () => {
                                        try {
                                            const data = await api.citizenSampleAnalysis()
                                            handleScoreUpdate(data)
                                        } catch (e) {
                                            console.error(e)
                                            alert('Failed to load sample data')
                                        }
                                    }}
                                    className="w-full py-3 px-4 bg-white border-2 border-slate-200 text-slate-600 rounded-xl hover:border-blue-500 hover:text-blue-600 font-semibold transition-all"
                                >
                                    Run Sample Analysis
                                </button>
                            </div>
                        </Card>
                    )}

                    {scoreData && (
                        <>
                            {/* Explanations */}
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <Card title="What's Helping" className="border-t-4 border-green-500">
                                    {scoreData.explanations.positive.length > 0 ? (
                                        <ul className="space-y-3">
                                            {scoreData.explanations.positive.map((item, i) => (
                                                <li key={i} className="flex items-start text-sm text-slate-700">
                                                    <svg className="w-5 h-5 text-green-500 mr-2 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                                    </svg>
                                                    {item}
                                                </li>
                                            ))}
                                        </ul>
                                    ) : (
                                        <p className="text-sm text-slate-400 italic">No significant positive factors yet.</p>
                                    )}
                                </Card>

                                <Card title="What's Hurting" className="border-t-4 border-red-400">
                                    {scoreData.explanations.negative.length > 0 ? (
                                        <ul className="space-y-3">
                                            {scoreData.explanations.negative.map((item, i) => (
                                                <li key={i} className="flex items-start text-sm text-slate-700">
                                                    <svg className="w-5 h-5 text-red-400 mr-2 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                                                    </svg>
                                                    {item}
                                                </li>
                                            ))}
                                        </ul>
                                    ) : (
                                        <p className="text-sm text-slate-400 italic">No significant negative factors found.</p>
                                    )}
                                </Card>
                            </div>

                            {/* Action Plan */}
                            <Card title="Your Action Plan">
                                <div className="space-y-6">
                                    <div>
                                        <h4 className="text-sm font-semibold text-slate-900 uppercase tracking-wider mb-3">Key Improvements</h4>
                                        <div className="space-y-3">
                                            {scoreData.improvements.map((imp, i) => (
                                                <div key={i} className="flex justify-between items-center p-3 bg-blue-50 border border-blue-100 rounded-lg">
                                                    <div className="flex items-center">
                                                        <span className="flex items-center justify-center w-6 h-6 rounded-full bg-blue-100 text-blue-600 text-xs font-bold mr-3">
                                                            {i + 1}
                                                        </span>
                                                        <span className="text-sm font-medium text-slate-800">{imp.action}</span>
                                                    </div>
                                                    <span className="text-xs font-bold text-blue-600 bg-white px-2 py-1 rounded shadow-sm">
                                                        {imp.impact}
                                                    </span>
                                                </div>
                                            ))}
                                        </div>
                                    </div>

                                    {scoreData.recommendations.tips.length > 0 && (
                                        <div>
                                            <h4 className="text-sm font-semibold text-slate-900 uppercase tracking-wider mb-3">Smart Tips</h4>
                                            <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                                                {scoreData.recommendations.tips.map((tip, i) => (
                                                    <div key={i} className="text-xs text-slate-600 bg-slate-50 p-2 rounded border border-slate-100">
                                                        💡 {tip}
                                                    </div>
                                                ))}
                                            </div>
                                        </div>
                                    )}
                                </div>
                            </Card>

                            <div className="flex justify-end">
                                <button
                                    onClick={() => setScoreData(null)}
                                    className="text-sm text-slate-500 hover:text-slate-800"
                                >
                                    Start Over
                                </button>
                            </div>
                        </>
                    )}
                </div>
            </div>
        </Layout>
    )
}
